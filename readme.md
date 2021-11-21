Bài test GLT token

Token này chưa hoàn chỉnh, chưa có phần test với truffle.
Nội dung của token bao gồm các tính năng:
- private sale với việc chuyển token cho một ví. Các ví private sale bị block sau một khoảng thời gian sẽ bắt đầu rút được. Và sẽ unlock dần dần theo ngày.
- public sale với việc đăng ký whitelist, và đến một ngày nào đó các whitelist này  sẽ được nhận một lượng token nhất định.
- Các nhóm token khác sẽ được chuyển tương ứng

Hầu hết các code trong thư mục ERC20, access, util đều được copy và tham khảo từ các nguồn khác nhau.

Hiện tại trong phần public sale có phần chuyển tiền vẫn chưa thể thực hiện. Import from backup file để recover lại project này.