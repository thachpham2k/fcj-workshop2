---
title : "Cài đặt và cấu hình AWS CLI"
menuTitle : "AWS CLI"
date : "`r Sys.Date()`"
weight : 1
chapter : false
pre : " <b> 2.1. </b> "
description: "Hướng dẫn cài đặt và cấu hình AWS CLI trên terminal"
---

## Tổng quan

{{% notice info %}}
AWS Command Line Interface (CLI) là một công cụ cho phép bạn tương tác với các dịch vụ của AWS thông qua dòng lệnh trên terminal.
{{% /notice %}}

Mặc dù AWS CLI là một công cụ dòng lệnh được sử dụng trên terminal, nhưng AWS CLI không hỗ trợ **man page**. Vậy làm sao để tra cứu lệnh?

- **Trên Terminal**: Nếu bạn muốn tra cứu lệnh trực tiếp trên terminal, bạn có thể sử dụng:
  - Từ khóa `help`: Tương tự như **man page**, AWS CLI sẽ cung cấp danh sách các lệnh, ý nghĩa và nhiều thông tin liên quan đến lệnh bạn cần tìm. Từ khóa `help` không bắt buộc đặt ở sau từ khóa `aws`, bạn có thể đặt ở bất kỳ vị trí nào mà bạn không biết nên viết gì. Ví dụ: `aws s3 help`, `aws s3 ls help`,...
  - Đôi khi từ khóa `help` cung cấp quá nhiều thông tin dư thừa, và bạn chỉ muốn tìm kiếm từ khóa mà không cần giải thích lệnh, lúc đó bạn có thể sử dụng từ khóa `?`. Từ khóa `?` sẽ cung cấp các từ khóa liên quan đến lệnh mà bạn đang tìm kiếm. Ví dụ: `aws ?`, `aws s3 ?`,.. Vị trí đặt từ khóa `?` giống với khi sử dụng từ khóa `help`, tuy nhiên từ khóa `?` chỉ có thể đặt ở vị trí mà đáng ra nó phải đặt một từ khóa của lệnh. Ví dụ: có thể `aws s3 ?` nhưng không thể `aws s3 ls ?`.
  
- **Web Browser**: Mặc dù rất thích thao tác với terminal nhưng mình vẫn thấy sử dụng web để tra cứu là dễ hiểu nhất. Trang tra cứu lệnh của AWS CLI cung cấp rất chi tiết về lệnh như mô tả, tùy chọn, biến, ví dụ,... rất dễ hiểu. Trang tra cứu lệnh là `https://docs.aws.amazon.com/cli/latest/`, nếu bạn muốn tra cứu lệnh liên quan đến S3 thì là `https://docs.aws.amazon.com/cli/latest/reference/s3`, còn muốn xem chi tiết về lệnh `aws s3 ls` thì là `https://docs.aws.amazon.com/cli/latest/reference/s3/ls.html`. Một mẹo khi sử dụng là sau khi tìm được lệnh, bạn nên đi trực tiếp xuống phần ví dụ để xem cách sử dụng, sau đó mới quay lại xem các tùy chọn của nó. Hãy thử, có thể nó cũng phù hợp với bạn.

## Nội dung

1. Cài đặt AWS CLI
    
    Sử dụng các lệnh sau để cài đặt AWS CLI V2:

    ```shell
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    # Xóa gói cài đặt
    rm -rf awscliv2.zip aws/install
    # Kiểm tra phiên bản AWS CLI
    aws --version
    ```
    
    {{% notice note %}}
Hướng dẫn này chỉ áp dụng cho hệ điều hành Linux.   
Để biết thêm chi tiết về cách cài đặt AWS CLI trên các nền tảng khác hoặc cách cập nhật AWS CLI lên phiên bản 2, vui lòng [xem tại đây](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
    {{% /notice %}}
    
2. Cấu Hình AWS CLI

    Để cấu hình AWS CLI, chúng ta sử dụng lệnh:

    ```shell
    aws configure
    ```

    Bạn cần nhập 4 giá trị là `Access Key ID`, `Secret Access Key`, `Region` và `Default output format`.

    ![AWS CLI config](/images/2-prerequiste/2.1-aws-cli/2.1.1-cli-config.png)

    {{% notice note %}}
Nếu bạn chưa biết hoặc chưa có **Access Key** ID và **Secret Access Key** của AWS, vui lòng tham khảo hướng dẫn [Managing access keys for IAM users](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)   
Để tìm hiểu thêm về lệnh `aws configure` hoặc gặp sự cố, vui lòng tham khảo hướng dẫn [Authenticate with IAM user credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-authentication-user.html).    
Tra cứu **AWS region code**: tại [Regions and Zones](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-regions)    
    {{% /notice %}}

    {{% notice tip %}}
Sau khi sử dụng lệnh `aws configure`, một thư mục có tên `.aws` sẽ được tạo trong thư mục `~` (thư mục chính của người dùng), bao gồm 2 tệp là `config` (chứa thông tin về vùng và định dạng xuất mặc định) và `credentials` (chứa Access Key ID và Secret Access Key). Thay vì sử dụng `aws configure`, bạn cũng có thể sử dụng các lệnh sau:
    {{% /notice %}}

    ```shell
    cat <<EOF | tee ~/.aws/config
    [default]
    region = ap-southeast-1
    output = json
    EOF
    cat <<EOF | tee ~/.aws/credentials
    [default]
    aws_access_key_id = abc
    aws_secret_access_key = abc
    EOF
    ```
    
3. Kiểm tra cấu hình

    Ngoài cách cấu hình AWS CLI bằng lệnh `aws configure`, bạn cũng có thể sử dụng biến môi trường (biến PATH), ... nên có lúc cấu hình bằng aws configure sẽ không được chấp nhận.
    
    Sau khi cấu hình, bạn nên kiểm tra lại bằng cách sử dụng lệnh:

    ```shell
    aws configure list
    ```

    | 👉 Trong ảnh dưới đây, mặc dù lệnh `aws configure` đã cấu hình vùng là `ap-southeast-1`, nhưng AWS CLI vẫn nhận giá trị `us-east-2` từ biến AWS_REGION.

    ![AWS Configure conflict](/images/2-prerequiste/2.1-aws-cli/2.1.2-bug.png)

## Tham khảo

Để tìm hiều thêm vể AWS CLI: tham khảo [aws cli document](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)