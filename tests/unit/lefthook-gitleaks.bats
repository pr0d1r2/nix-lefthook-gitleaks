#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"

    TMP="$BATS_TEST_TMPDIR"
}

@test "no args exits 0" {
    run lefthook-gitleaks
    assert_success
}

@test "non-existent file is skipped" {
    run lefthook-gitleaks /nonexistent/file.txt
    assert_success
}

@test "file with no secrets passes" {
    cat > "$TMP/clean.txt" <<'EOF'
This is a clean file with no secrets.
username = "admin"
EOF
    run lefthook-gitleaks "$TMP/clean.txt"
    assert_success
}

@test "file with secret fails" {
    cat > "$TMP/secret.txt" <<'EOF'
api_key = "sk-1234567890abcdef1234567890abcdef"
EOF
    run lefthook-gitleaks "$TMP/secret.txt"
    assert_failure
}

@test "multiple files: one with secret causes failure" {
    printf 'This is clean text.\n' > "$TMP/clean.txt"
    cat > "$TMP/secret.txt" <<'EOF'
api_key = "sk-1234567890abcdef1234567890abcdef"
EOF
    run lefthook-gitleaks "$TMP/clean.txt" "$TMP/secret.txt"
    assert_failure
}
