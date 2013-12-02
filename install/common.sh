

# test that an image exists
function test_image() {
	version=$1
	image=cassandra:$version
	sudo docker history $image > /dev/null 2> /dev/null
	if [[ $? != 0 ]]; then
		echo "Could not find Docker image $image, use 'make image VERSION=$version' to build it"
		exit 1
	fi
}

# Argc test + usage help
function check_usage() {
	argc=$1
	expected=$2
	usage=$3

	if [[ $argc -ne $expected ]]; then
		echo -e $usage
		exit 1
	fi
}
