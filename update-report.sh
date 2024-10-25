output=$(nix store diff-closures $(ls -d /nix/var/nix/profiles/* | tail -2) | sed -r "s/\x1B\[[0-9;]*[mK]//g")

# Replace newline characters with spaces for a more horizontal notification
formatted_output=$(echo "$output" | awk '
{
    # Extract package name, version, and size from the input line
    if (match($0, /^([^:]+):.*→ ([^,]+), \+([0-9.]+) KiB/, arr)) {
        package = arr[1]
        full_version = arr[2]
        size_kib = arr[3]

        # Extract only the first and second numbers of the version
        split(full_version, version_parts, ".")
        version = version_parts[1] "." version_parts[2]

        # Convert KiB to MiB and round to the nearest whole number if needed
        size_mib = size_kib / 1024
        size_mib_rounded = (size_mib >= 1) ? sprintf("%.0f", size_mib) "M" : size_kib "KiB"

        # Create the formatted output line with special characters to make it stand out
        printf "🔹 %s: %s +%s\n", package, version, size_mib_rounded
    }
}')
notify-send -u low -h string:x-mako-stack-tag:diff "💫 Updated Packages" "$formatted_output" -t 0 -u critical

