FROM swift:latest
LABEL com.swiftdockercli.action="build"
LABEL com.swiftdockercli.folder="logging-kit"
COPY . /logging-kit
WORKDIR /logging-kit
RUN swift build
RUN swift test --enable-test-discovery