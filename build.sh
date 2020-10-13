VERSION=12

echo "Building for Node $VERSION"

docker build \
--build-arg NODE_VERSION="$VERSION" \
-t canvas-layers .

docker run -d --rm \
--mount type=bind,source="$(pwd)",target=/out canvas-layers \
/out/layers.zip \
/root/layers

# wait for the zip file to complete
echo "Compressing Layers..."
while [ ! -f ./layers.zip ]; do sleep 1; done

unzip -o ./layers.zip -d .

rm layers.zip
