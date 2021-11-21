// SPDX-License-Identifier: MIT
// contract tự viết =))
pragma solidity 0.8.6;

import "./access/Ownable.sol";
import "./ERC20/IERC20.sol";

/**
 * Chiến thuật bán public sale như sau:
 * - Bán giá fix theo ether, mỗi ether đối được một số lượng GLT nhất định
 * - Chỉ cho phép các địa chỉ trong whitelist mua, mỗi địa chỉ chỉ được mua một lượng token tối đa và tối thiểu
 * - Chỉ mở bán token trong một khoảng thời gian
 * - Sau khi mua, token bị lock và có thể được unlock mỗi ngày 1%
 * - Tất cả ETH thu được sẽ chuyển về tài khoản của người deploy
 * 
 * Lưu ý: Deploy bằng tài khoản chứa token dành cho public sale (15% tổng cung). Giữ tài khoản này có đủ số lượng token để user đã mua có thể claim được
 */
contract GLTSaleStrategy is Ownable{
    IERC20 public GLT_Token;
    
    address payable public wallet;
    // Ngày bắt đầu mở bán
    uint256 public startSaleDate=1637512485;
    // Ngày dừng mở bán
    uint256 public endSaleDate=1640104494;
    // Số lượng token tối đa mà 1 user được mua
    uint256 public maxTokensPerUser = 10000000000000000000000; //ForTesting: 10.000 tokens
    // Số lượng token tối thiểu mà 1 user phải mua
    uint256 public minTokensPerUser=1000000000000000000; //ForTesting: 1 token
    // Thời gian unlock hết số token. Thời gian tính bằng ngày từ lúc mua token. Số token sẽ unlock hàng ngày đển khi hết thời gian này.
    uint16 public unlockDays=10;
    // Giá bán dựa vào tỷ lệ chuyển đổi từ ether sang token GLT
    uint256 public rate = 10e13; //ForTesting: 1 ether = 10.000 token
    
    // key= địa chỉ dc whitelist, value là ngày mua whitelist. Nếu chưa mua thì value =1
    mapping(address => uint256) private whitelistDate;
    // Số token mà user mua chưa thể lấy về
    mapping(address => uint256) private whitelistBlockedTokens;
    address[] private whitelist;
    
    
    constructor(IERC20 _glt){
        GLT_Token = IERC20(_glt);
        wallet = payable(msg.sender);
        whitelistDate[0xdD870fA1b7C4700F2BD7f44238821C26f7392148]=1;
        whitelistDate[0x583031D1113aD414F02576BD6afaBfb302140225]=1;
        
        whitelist.push(0xdD870fA1b7C4700F2BD7f44238821C26f7392148);
        whitelist.push(0x583031D1113aD414F02576BD6afaBfb302140225);
        
    }
    
    modifier inSaleTime{
        require(block.timestamp > startSaleDate, "It's not time to sell yet!");
        require(block.timestamp < endSaleDate, "The sale has ended!");
        _;
    }
    
    modifier oneTimetoBuy{
        require(whitelistDate[msg.sender] == 1, "You can't buy!");
        _;
    }
    
    event Claim(address indexed claimAddress, uint256 amount);
    
    /**
     * Tự động quy đổi số ether gửi kèm giao dịch thành số token. Trả lại số token đã mua thành công. Hành động này call từ người dùng.
     */
    function buyPublicSale() external payable inSaleTime oneTimetoBuy returns (uint256){
        // Tính số token theo giá quy đổi
        uint256 num = msg.value/rate * 10e17;
        require(num>=minTokensPerUser, "Quantity purchased is too small!");
        require(num<=maxTokensPerUser, "Quantity purchased is too large!");
        whitelistDate[msg.sender]=block.timestamp;
        whitelistBlockedTokens[msg.sender]=num;
       
        wallet.transfer(msg.value);
        return num;
    }
    

    
    // Số token có thể clame được. Hành động này chỉ call từ owner để trả token về cho user đã mua
    function claim() public returns (uint) {
        require(owner() == msg.sender);
        for(uint i=0; i<whitelist.length; i++){
       
            uint16 dayAfter = uint16((block.timestamp - whitelistDate[whitelist[i]])/15);
            uint256 numtoken = whitelistBlockedTokens[whitelist[i]]*dayAfter/unlockDays;
            
            emit Claim(whitelist[i],numtoken);
            
            // Phần này không thể chuyển token đi được???
            GLT_Token.transfer(whitelist[i],1);
        
        }
        return GLT_Token.balanceOf(msg.sender);
    }
    

    
}