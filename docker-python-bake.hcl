group "default" {
    targets = ["builder", "python311", "python312", "python313"]
}

target "builder" {
    dockerfile = "Dockerfile.builder"
    tags = ["docker.io/codeplox-dev/ubu2404-python-base"]
    platforms = [
      #"linux/amd64",
      "linux/arm64",
    ]
    #attest = [
    #  "type=provenance,mode=max",
    #  "type=sbom",
    #]
}

target "python311" {
    dockerfile = "Dockerfile.python311"
    tags = ["docker.io/codeplox-dev/ubu2404-python-311"]
    platforms = [
      #"linux/amd64",
      "linux/arm64",
    ]
    contexts = {
        ubu2404-python-base = "target:builder"
    }
    #attest = [
    #  "type=provenance,mode=max",
    #  "type=sbom",
    #]
}

target "python312" {
    dockerfile = "Dockerfile.python312"
    tags = ["docker.io/codeplox-dev/ubu2404-python-312"]
    platforms = [
      #"linux/amd64",
      "linux/arm64",
    ]
    contexts = {
        ubu2404-python-base = "target:builder"
    }
    #attest = [
    #  "type=provenance,mode=max",
    #  "type=sbom",
    #]
}

target "python313" {
    dockerfile = "Dockerfile.python311"
    tags = ["docker.io/codeplox-dev/ubu2404-python-313"]
    platforms = [
      #"linux/amd64",
      "linux/arm64",
    ]
    contexts = {
        ubu2404-python-base = "target:builder"
    }
    #attest = [
    #  "type=provenance,mode=max",
    #  "type=sbom",
    #]
}
