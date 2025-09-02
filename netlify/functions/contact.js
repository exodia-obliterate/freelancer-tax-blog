exports.handler = async (event) => {
  if (event.httpMethod !== 'POST') { return { statusCode: 405, body: 'Method Not Allowed' }; }
  const ct = (event.headers['content-type'] || '').toLowerCase()
  let data = {}
  if (ct.includes('application/x-www-form-urlencoded')) { data = require('querystring').parse(event.body || '') }
  else if (ct.includes('application/json')) { data = JSON.parse(event.body || '{}') }
  console.log('contact submission', data)
  return { statusCode: 303, headers: { Location: '/thank-you/' }, body: '' }
}
