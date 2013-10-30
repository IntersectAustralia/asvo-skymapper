#= require skymapper/helpers/raw_image_order

createObj = (ra, dec, filter, date) ->
  {
    POINTRA_DEG: ra,
    POINTDEC_DEG: dec,
    FILTER: filter,
    IMAGE_TYPE: '',
    DATE: date,
  }

describe 'RawImageOrder', ->

  it 'orders fields by ra', ->
    fields = ['POINTRA_DEG', 'POINTDEC_DEG', 'FILTER', 'IMAGE_TYPE', 'DATE']
    expect(rawImageOrder(fields, createObj('1', '2', 'u', '12345'), createObj('2', '2', 'u', '12345'))).toEqual(-1)
    expect(rawImageOrder(fields, createObj('2', '2', 'u', '12345'), createObj('1', '2', 'u', '12345'))).toEqual(1)
    expect(rawImageOrder(fields, createObj('1', '2', 'u', '12345'), createObj('1', '2', 'u', '12345'))).toEqual(0)

  it 'orders fields by dec', ->
    fields = ['POINTRA_DEG', 'POINTDEC_DEG', 'FILTER', 'IMAGE_TYPE', 'DATE']
    expect(rawImageOrder(fields, createObj('1', '1', 'u', '12345'), createObj('1', '2', 'u', '12345'))).toEqual(-1)
    expect(rawImageOrder(fields, createObj('1', '2', 'u', '12345'), createObj('1', '1', 'u', '12345'))).toEqual(1)
    expect(rawImageOrder(fields, createObj('1', '2', 'u', '12345'), createObj('1', '2', 'u', '12345'))).toEqual(0)

  it 'orders fields by filter', ->
    fields = ['POINTRA_DEG', 'POINTDEC_DEG', 'FILTER', 'IMAGE_TYPE', 'DATE']
    expect(rawImageOrder(fields, createObj('1', '1', 'u', '12345'), createObj('1', '1', 'u', '12345'))).toEqual(0)
    expect(rawImageOrder(fields, createObj('1', '1', 'u', '12345'), createObj('1', '1', 'v', '12345'))).toEqual(-1)
    expect(rawImageOrder(fields, createObj('1', '1', 'u', '12345'), createObj('1', '1', 'g', '12345'))).toEqual(-1)
    expect(rawImageOrder(fields, createObj('1', '1', 'u', '12345'), createObj('1', '1', 'r', '12345'))).toEqual(-1)
    expect(rawImageOrder(fields, createObj('1', '1', 'u', '12345'), createObj('1', '1', 'i', '12345'))).toEqual(-1)
    expect(rawImageOrder(fields, createObj('1', '1', 'u', '12345'), createObj('1', '1', 'z', '12345'))).toEqual(-1)

    expect(rawImageOrder(fields, createObj('1', '1', 'v', '12345'), createObj('1', '1', 'u', '12345'))).toEqual(1)
    expect(rawImageOrder(fields, createObj('1', '1', 'v', '12345'), createObj('1', '1', 'v', '12345'))).toEqual(0)
    expect(rawImageOrder(fields, createObj('1', '1', 'v', '12345'), createObj('1', '1', 'g', '12345'))).toEqual(-1)
    expect(rawImageOrder(fields, createObj('1', '1', 'v', '12345'), createObj('1', '1', 'r', '12345'))).toEqual(-1)
    expect(rawImageOrder(fields, createObj('1', '1', 'v', '12345'), createObj('1', '1', 'i', '12345'))).toEqual(-1)
    expect(rawImageOrder(fields, createObj('1', '1', 'v', '12345'), createObj('1', '1', 'z', '12345'))).toEqual(-1)

    expect(rawImageOrder(fields, createObj('1', '1', 'g', '12345'), createObj('1', '1', 'u', '12345'))).toEqual(1)
    expect(rawImageOrder(fields, createObj('1', '1', 'g', '12345'), createObj('1', '1', 'v', '12345'))).toEqual(1)
    expect(rawImageOrder(fields, createObj('1', '1', 'g', '12345'), createObj('1', '1', 'g', '12345'))).toEqual(0)
    expect(rawImageOrder(fields, createObj('1', '1', 'g', '12345'), createObj('1', '1', 'r', '12345'))).toEqual(-1)
    expect(rawImageOrder(fields, createObj('1', '1', 'g', '12345'), createObj('1', '1', 'i', '12345'))).toEqual(-1)
    expect(rawImageOrder(fields, createObj('1', '1', 'g', '12345'), createObj('1', '1', 'z', '12345'))).toEqual(-1)

    expect(rawImageOrder(fields, createObj('1', '1', 'r', '12345'), createObj('1', '1', 'u', '12345'))).toEqual(1)
    expect(rawImageOrder(fields, createObj('1', '1', 'r', '12345'), createObj('1', '1', 'v', '12345'))).toEqual(1)
    expect(rawImageOrder(fields, createObj('1', '1', 'r', '12345'), createObj('1', '1', 'g', '12345'))).toEqual(1)
    expect(rawImageOrder(fields, createObj('1', '1', 'r', '12345'), createObj('1', '1', 'r', '12345'))).toEqual(0)
    expect(rawImageOrder(fields, createObj('1', '1', 'r', '12345'), createObj('1', '1', 'i', '12345'))).toEqual(-1)
    expect(rawImageOrder(fields, createObj('1', '1', 'r', '12345'), createObj('1', '1', 'z', '12345'))).toEqual(-1)

    expect(rawImageOrder(fields, createObj('1', '1', 'i', '12345'), createObj('1', '1', 'u', '12345'))).toEqual(1)
    expect(rawImageOrder(fields, createObj('1', '1', 'i', '12345'), createObj('1', '1', 'v', '12345'))).toEqual(1)
    expect(rawImageOrder(fields, createObj('1', '1', 'i', '12345'), createObj('1', '1', 'g', '12345'))).toEqual(1)
    expect(rawImageOrder(fields, createObj('1', '1', 'i', '12345'), createObj('1', '1', 'r', '12345'))).toEqual(1)
    expect(rawImageOrder(fields, createObj('1', '1', 'i', '12345'), createObj('1', '1', 'i', '12345'))).toEqual(0)
    expect(rawImageOrder(fields, createObj('1', '1', 'i', '12345'), createObj('1', '1', 'z', '12345'))).toEqual(-1)

    expect(rawImageOrder(fields, createObj('1', '1', 'z', '12345'), createObj('1', '1', 'u', '12345'))).toEqual(1)
    expect(rawImageOrder(fields, createObj('1', '1', 'z', '12345'), createObj('1', '1', 'v', '12345'))).toEqual(1)
    expect(rawImageOrder(fields, createObj('1', '1', 'z', '12345'), createObj('1', '1', 'g', '12345'))).toEqual(1)
    expect(rawImageOrder(fields, createObj('1', '1', 'z', '12345'), createObj('1', '1', 'r', '12345'))).toEqual(1)
    expect(rawImageOrder(fields, createObj('1', '1', 'z', '12345'), createObj('1', '1', 'i', '12345'))).toEqual(1)
    expect(rawImageOrder(fields, createObj('1', '1', 'z', '12345'), createObj('1', '1', 'z', '12345'))).toEqual(0)

  it 'orders fields by date', ->
    fields = ['POINTRA_DEG', 'POINTDEC_DEG', 'FILTER', 'IMAGE_TYPE', 'DATE']
    expect(rawImageOrder(fields, createObj('1', '1', 'u', '12345'), createObj('1', '1', 'u', '12346'))).toEqual(-1)
    expect(rawImageOrder(fields, createObj('1', '1', 'u', '12346'), createObj('1', '1', 'u', '12345'))).toEqual(1)
    expect(rawImageOrder(fields, createObj('1', '1', 'u', '12345'), createObj('1', '1', 'u', '12345'))).toEqual(0)


