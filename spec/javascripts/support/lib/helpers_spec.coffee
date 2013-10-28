#= require lib/helpers

describe 'Helpers', ->

  it 'can decode search params', ->
    params = {
      query: {
        ra: '178.83871',
        dec: '-1.18844',
        sr: '0.5'
      }
    }

    result = decodeQueryParams(encodeQueryParams(params))
    expect(result['query[ra]']).toBe '178.83871'
    expect(result['query[dec]']).toBe '-1.18844'
    expect(result['query[sr]']).toBe '0.5'