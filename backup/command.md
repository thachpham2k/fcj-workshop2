## Combine 2 json
```shell
# -c: compact-output: oneline
echo $tags | jq -c '. + [{"Key":"Name","Value":"'"$rds_subnet_group_name"'"}]'
echo 'ResourceType=subnet,Tags=[{Key=Name,Value='$prisubnet3_name'},'$tagspec`

grep '^echo ' backup/command.sh | awk '!seen[$0]++'  > abc.txt

# Duyệt qua tất cả các file bắt đầu bằng "3.1."
for file in 3.1.*; do
  # Kiểm tra xem file có tồn tại không
  if [[ -f "$file" ]]; then
    # Đổi tên file bằng cách thay thế "3.1." bằng "2.7."
    mv "$file" "${file/3.1./2.7.}"
  fi
done
```