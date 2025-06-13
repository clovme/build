import { requestAjax } from '@/api/http.ts'

export function getFormConfig (params?: any) {
  return requestAjax({
    url: '/initialize',
    method: 'get',
    params
  })
}

export function postFormConfig (data?: any) {
  return requestAjax({
    url: '/initialize',
    method: 'post',
    data
  })
}
