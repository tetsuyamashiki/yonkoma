#!/bin/bash

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 画像圧縮スクリプト（強化版）
# 実行方法: sh compress_images.sh
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

cd "$(dirname "$0")"

if [ ! -d "images" ]; then
  echo "❌ imagesフォルダが見つかりません"
  exit 1
fi

echo "🔄 画像を圧縮しています..."
count=0
total=$(ls images/*.jpg images/*.jpeg images/*.png 2>/dev/null | wc -l | tr -d ' ')
before_total=0
after_total=0

for img in images/*.jpg images/*.jpeg images/*.png; do
  [ -f "$img" ] || continue

  before=$(wc -c < "$img")
  before_total=$((before_total + before))

  # 幅620px（サイト表示幅に最適化）に縮小
  sips --resampleWidth 620 "$img" --out "$img" > /dev/null 2>&1
  # JPEG品質75%に圧縮
  sips -s format jpeg -s formatOptions 75 "$img" --out "$img" > /dev/null 2>&1

  after=$(wc -c < "$img")
  after_total=$((after_total + after))

  count=$((count + 1))
  before_kb=$((before / 1024))
  after_kb=$((after / 1024))
  echo "  ✅ ($count/$total) ${before_kb}KB → ${after_kb}KB  $img"
done

before_mb=$((before_total / 1024 / 1024))
after_mb=$((after_total / 1024 / 1024))

echo ""
echo "🎉 完了！ ${count}枚を圧縮しました"
echo "📦 合計サイズ: ${before_mb}MB → ${after_mb}MB"
echo ""
echo "Netlifyに再アップロードしてください"
