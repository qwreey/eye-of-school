#

학교 컴퓨터들을 관리하기 위해서, vpn 사용 이력과 설치된 프로그램을 서버에 기록하고 웹 클라이언트를 통해 선생님 혹은 관리자에게 현황을 보고합니다.

# 사용 기술 요약

## 서버측(백엔드)

nodejs(typescript) 와 fastify 를 이용해 api 를 구현했습니다.
데이터를 저장하기 위해서 mongodb 를 사용합니다.

## 웹클라이언트(프론트엔드)

svelte 와 typescript (vite) 를 이용합니다. SPA(single page application) 상태이기 때문에 단순히 index.html 만 배포하면 되어, sveltekit 을 사용하지 않았습니다.

## 데몬(대상 PC 용 클라이언트)

node 대비 비교적 가벼우며 (패키징 후 용량 10배 가량 가벼움) 빠르고 적은 의존성으로 데몬을 작성 할 수 있는 luvit 를 사용했습니다

# 설치

추후 작성 예정
