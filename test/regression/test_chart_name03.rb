# -*- coding: utf-8 -*-
require 'helper'

class TestChartName03 < Test::Unit::TestCase
  def setup
    setup_dir_var
  end

  def teardown
    File.delete(@xlsx) if File.exist?(@xlsx)
  end

  def test_chart_name03
    @xlsx = 'chart_name03.xlsx'
    workbook   = WriteXLSX.new(@xlsx)
    worksheet  = workbook.add_worksheet
    chart1     = workbook.add_chart(
                                    :type     => 'line',
                                    :embedded => 1,
                                    :name     => 'New 1'
                                    )

    chart2     = workbook.add_chart(
                                    :type     => 'line',
                                    :embedded => 1,
                                    :name     => 'New 2'
                                    )

    # For testing, copy the randomly generated axis ids in the target xls file.
    chart1.instance_variable_set(:@axis_ids, [44271104, 45703168])
    chart2.instance_variable_set(:@axis_ids, [80928128, 80934400])

    data = [
            [ 1, 2, 3, 4,  5 ],
            [ 2, 4, 6, 8,  10 ],
            [ 3, 6, 9, 12, 15 ]
           ]

    worksheet.write('A1', data)

    chart1.add_series(:values => '=Sheet1!$A$1:$A$5')
    chart1.add_series(:values => '=Sheet1!$B$1:$B$5')
    chart1.add_series(:values => '=Sheet1!$C$1:$C$5')

    chart2.add_series(:values => '=Sheet1!$A$1:$A$5')
    chart2.add_series(:values => '=Sheet1!$B$1:$B$5')
    chart2.add_series(:values => '=Sheet1!$C$1:$C$5')

    worksheet.insert_chart('E24', chart2)
    worksheet.insert_chart('E9',  chart1)

    workbook.close
    compare_xlsx_for_regression(
                                File.join(@regression_output, @xlsx),
                                @xlsx
                                )
  end
end
