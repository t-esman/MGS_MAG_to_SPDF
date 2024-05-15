pro read_barlow_from_csv
  testfile='partysize.csv'
  data = READ_CSV(testfile, HEADER=SedHeader, $
    N_TABLE_HEADER=1, TABLE_HEADER=SedTableHeader)

reservation_id_1 = data.field1
partysize=data.field2
resdatetime=data.field3
date_made=data.field5
guest_id_1=data.field6
array_size1=n_elements(reservation_id_1)
testfile='dateitemreservationgrat.csv'
data = READ_CSV(testfile, HEADER=SedHeader, $
  N_TABLE_HEADER=1, TABLE_HEADER=SedTableHeader)

check_id=data.field1
visit_date=data.field2
item_spend=data.field3
gratuity=data.field4
reservation_id_2=data.field5
revenue_center=data.field6
array_size2=n_elements(check_id)

testfile='itemnamebev.csv'
data = READ_CSV(testfile, HEADER=SedHeader, $
  N_TABLE_HEADER=1, TABLE_HEADER=SedTableHeader)

item_id=data.field1
pos_item_id=data.field2
item_name=data.field3
category_name=data.field4
subcat=data.field5
quantity = data.field6
check_id2=data.field7

array_size3=n_elements(item_id)
item_id_float=fltarr(array_size3-1)

 lobster=where(subcat eq 'Lobster')
total_lobster=total(quantity(lobster))

 steak=where(subcat eq 'Ribeye' or subcat eq 'NY & Double' or subcat eq 'Filet')
 total_steak=total(quantity(steak))

 check_id_steak=check_id2(steak)
check_id_lobster=check_id2(lobster)
whereLobster_excel2=fltarr(n_elements(check_id_lobster))
whereSteak_excel2=fltarr(n_elements(check_id_steak))
for i=0,n_elements(check_id_lobster)-1 do begin
  whereLobster_excel2(i)=where(check_id eq check_id_lobster(i))
endfor
for i=0,n_elements(check_id_steak)-1 do begin
  whereSteak_excel2(i)=where(check_id eq check_id_steak(i))
endfor

average_grat_lobster=mean(abs(gratuity(whereLobster_excel2)/item_spend(whereLobster_excel2)),/nan)
average_grat_steak=mean(abs(gratuity(whereSteak_excel2)/item_spend(whereSteak_excel2)),/nan)


average_itemspend_lobster=mean(item_spend(whereLobster_excel2))
average_itemspend_steak=mean(item_spend(whereSteak_excel2))

print, average_grat_lobster
print,average_grat_steak
print,'item spend'
print,average_itemspend_lobster
print,average_itemspend_steak







end