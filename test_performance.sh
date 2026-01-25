#!/bin/bash

echo "=== Testing Cache Performance ==="

# Warm up the cache
echo "Warming up cache..."
curl -s http://localhost:8080/locations -H "Authorization: Bearer YOUR_TOKEN" > /dev/null

echo ""
echo "=== Test 1: First request (cache miss) ==="
time curl -s http://localhost:8080/locations -H "Authorization: Bearer YOUR_TOKEN" > /dev/null

echo ""
echo "=== Test 2: Second request (cache hit - should be faster) ==="
time curl -s http://localhost:8080/locations -H "Authorization: Bearer YOUR_TOKEN" > /dev/null

echo ""
echo "=== Test 3: Third request (cache hit) ==="
time curl -s http://localhost:8080/locations -H "Authorization: Bearer YOUR_TOKEN" > /dev/null

# Clear cache
echo ""
echo "Clearing cache..."
redis-cli FLUSHALL

echo ""
echo "=== Test 4: After cache clear (cache miss) ==="
time curl -s http://localhost:8080/locations -H "Authorization: Bearer YOUR_TOKEN" > /dev/nullexit