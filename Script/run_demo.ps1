function Run-RedisDemo($file) {
    Get-Content $file |
    Where-Object { $_ -and $_ -notmatch '^\s*(#|--|//)' } |
    docker exec -i redis-lab redis-cli
}
