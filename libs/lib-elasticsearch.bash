esconfthresholdoff() {
  usage $# "[ES_URL:http://localhost:9200]"

  echo "Configuration disk thresholding alert off"
  
  local ES_URL=${1:-http://localhost:9200}
  curl -XPUT "${ES_URL}/_cluster/settings" -H 'Content-Type: application/json' -d'
  {
    "persistent": {
      "cluster": {
        "routing": {
          "allocation.disk.threshold_enabled": false
        }
      }
    }
  }'
}
