class TimeStamp
  def initialize(app)
    @app = app
  end

  def call(env)
    # Вызываем приложение и получаем его ответ
    prev_response = @app.call(env)
    status, headers, prev_body = prev_response

    # Если статус не 200, возвращаем предыдущий ответ без изменений,
    # чтобы не обрабатывать не успешные ответы
    return prev_response if status != 200

    # Получаем текущее время в формате строки
    current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S")

    # Добавляем текущее время к предыдущему телу ответа
    next_body = prev_body.push('</br>', "Текущее время: #{current_time}")

    # Возвращаем новый ответ с добавленным временем
    [status, headers, next_body]
  end
end
