## BJJ Eire Deploy – Helm Deployment Guide

This repository contains Helm charts and deployment assets for the BJJ Eire application:
- API: `bjj-eire-api/artifact`
- Web (frontend): `bjj-eire-web`
- MongoDB: `bjj-eire-mongodb`

### Prerequisites
- kubectl v1.26+
- Helm v3.10+
- Access to a Kubernetes cluster and the desired namespace
- Optional: Azure Key Vault + Secrets Store CSI Driver if using Azure-managed secrets
