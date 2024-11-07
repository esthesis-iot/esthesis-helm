#!/usr/bin/env bash
CHART_VERSION=$(grep '^version:' Chart.yaml | awk '{print $2}' | tr -d '"')
APP_VERSION=$(grep '^appVersion:' Chart.yaml | awk '{print $2}' | tr -d '"')
echo "CHART_VERSION: $CHART_VERSION"
echo "APP_VERSION: $APP_VERSION"

# Package the chart.
helm package .
