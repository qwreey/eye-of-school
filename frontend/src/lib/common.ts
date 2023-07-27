let monthAgoFormat = [
  "이번 달",
  "한 달",
  "두 달",
  "세 달",
  "네 달",
  "다섯 달",
  "여섯 달",
  "일곱 달",
  "여덟 달",
  "아홉 달",
  "열 달",
  "열한 달",
  "열두 달",
]

export function formatDateString(date:Date):string {
  let diff = (Date.now() - +date)/1000
  let ago = "미래"
  if (diff < 0) {
    ago = '방금 전'
  } else if (diff < 60) { // 분보다 작음
    ago = `${diff}초 전`
  } else if (diff < 3600) { // 시간보다 작음
    ago = `${Math.floor(diff/60)}분 전`
  } else if (diff < 86400) { // 하루보다 작음
    ago = `${Math.floor(diff/3600)}시간 전`
  } else if (diff < 604800) { // 일주일보다 작음
    ago = `${Math.floor(diff/86400)}일 전`
  } else if (diff < 2592000) { // 개월보다 작음 작음
    ago = `${Math.floor(diff/604800)}주 전`
  } else if (diff < 31536000) { // 1년 보다 작음
    ago = `${monthAgoFormat[Math.floor(diff/2592000)]} 전`
  } else {
    ago = `${Math.floor(diff/31536000)}년 전`
  }
  return `${date.getFullYear()}년 ${date.getMonth()+1}월 ${date.getDate()}일 ${date.getHours()}:${date.getMinutes()}:${date.getSeconds()} (${ago})`
}
