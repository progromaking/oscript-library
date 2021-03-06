﻿
#Использовать "../src"

Перем юТест;

Функция ПолучитьСписокТестов(Знач Тестирование) Экспорт
	
	юТест = Тестирование;
	
	Тесты = Новый Массив;
	
	Тесты.Добавить("ТестДолжен_ЗаписатьМанифестВXML");
	Тесты.Добавить("ТестДолжен_ЗаписатьМетаданныеВXML");
	Тесты.Добавить("ТестДолжен_ПрочитатьМанифестИзXML");
	
	Возврат Тесты;
	
КонецФункции

Функция СоздатьТестовыйМанифест()
	
	Манифест = Новый ОписаниеПакета();
	Манифест.Имя("mft-test")
		.Автор("Я")
		.Версия("1.0.5")
		.ВерсияСреды("1.0")
		.Описание("Это пакет для тестирования")
		.АдресАвтора("mail@server.com")
		.ЗависитОт("asserts")
		.ЗависитОт("cmdline",">=2.1","<3.0")
		.ВключитьФайл("src")
		.ВключитьФайл("tests")
		.ОпределяетМодуль("Модуль1", "src/m1.os")
		.ОпределяетМодуль("Модуль2", "src/m2.os")
		.ОпределяетКласс("Класс1", "src/class1.os")
		.ОпределяетКласс("Класс2", "src/class2.os")
		.ИсполняемыйФайл("src/app1.os")
		.ИсполняемыйФайл("src/app2.os");
		
	Возврат Манифест;
	
КонецФункции

Процедура ЗаписатьМанифест(Знач Запись, Знач Манифест)
	Сериализатор = Новый СериализацияМетаданныхПакета;
	Сериализатор.ЗаписатьXML(Запись, Манифест);
КонецПроцедуры

Процедура ТестДолжен_ЗаписатьМанифестВXML() Экспорт
	
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	
	ЗаписатьМанифест(Запись, СоздатьТестовыйМанифест());
	
	Результат = СтрЗаменить(Запись.Закрыть(), Символы.ВК+Символы.ПС, Символы.ПС);

	Эталон = 
	"<?xml version=""1.0"" encoding=""utf-8""?>
	|<opm-metadata xmlns=""http://oscript.io/schemas/opm-metadata/1.0"">
	|    <name>mft-test</name>
	|    <author>Я</author>
	|    <version>1.0.5</version>
	|    <engine-version>1.0</engine-version>
	|    <description>Это пакет для тестирования</description>
	|    <author-email>mail@server.com</author-email>
	|    <depends-on name=""asserts"" />
	|    <depends-on name=""cmdline"" version=""&gt;=2.1"" version-max=""&lt;3.0"" />
	|    <executable>src/app1.os</executable>
	|    <executable>src/app2.os</executable>
	|    <include-content>src</include-content>
	|    <include-content>tests</include-content>
	|    <explicit-modules>
	|        <module name=""Модуль1"" src=""src/m1.os"" />
	|        <module name=""Модуль2"" src=""src/m2.os"" />
	|        <class name=""Класс1"" src=""src/class1.os"" />
	|        <class name=""Класс2"" src=""src/class2.os"" />
	|    </explicit-modules>
	|</opm-metadata>";
	
	юТест.ПроверитьРавенство(Эталон, Результат);

КонецПроцедуры

Процедура ТестДолжен_ЗаписатьМетаданныеВXML() Экспорт
	
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	
	Сериализатор = Новый СериализацияМетаданныхПакета;
	Сериализатор.ЗаписатьМетаданныеВXML(Запись, СоздатьТестовыйМанифест());
	
	Результат = СтрЗаменить(Запись.Закрыть(), Символы.ВК+Символы.ПС, Символы.ПС);

	Эталон = 
	"<?xml version=""1.0"" encoding=""utf-8""?>
	|<opm-metadata xmlns=""http://oscript.io/schemas/opm-metadata/1.0"">
	|    <name>mft-test</name>
	|    <author>Я</author>
	|    <version>1.0.5</version>
	|    <engine-version>1.0</engine-version>
	|    <description>Это пакет для тестирования</description>
	|    <author-email>mail@server.com</author-email>
	|    <depends-on name=""asserts"" />
	|    <depends-on name=""cmdline"" version=""&gt;=2.1"" version-max=""&lt;3.0"" />
	|    <executable>src/app1.os</executable>
	|    <executable>src/app2.os</executable>
	|</opm-metadata>";
	
	юТест.ПроверитьРавенство(Эталон, Результат);

КонецПроцедуры


Процедура ТестДолжен_ПрочитатьМанифестИзXML() Экспорт
	
	Манифест = СоздатьТестовыйМанифест();
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	ЗаписатьМанифест(Запись, Манифест);
	Текст = Запись.Закрыть();
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(Текст);
	
	Сериализатор = Новый СериализацияМетаданныхПакета();
	ПрочитанныйМанифест = Сериализатор.ПрочитатьXML(Чтение);
	
	юТест.ПроверитьРавенство(Тип("ОписаниеПакета"), ТипЗнч(ПрочитанныйМанифест), "Сравниваем типы до и после сериализации");
	
	СвойстваИсходного    = Манифест.Свойства();
	СвойстваПрочитанного = ПрочитанныйМанифест.Свойства();
	
	юТест.ПроверитьРавенство(СвойстваИсходного.Количество(), СвойстваПрочитанного.Количество(), "Количество свойств");
	Для Каждого КЗ Из СвойстваИсходного Цикл
		юТест.ПроверитьРавенство(КЗ.Значение, СвойстваПрочитанного[КЗ.Ключ], "Проверка свойства " + КЗ.Ключ);
	КонецЦикла;
	
	ЗависимостиИсходного = Манифест.Зависимости();
	ЗависимостиПроверяемого = ПрочитанныйМанифест.Зависимости();
	
	юТест.ПроверитьИстину(ТаблицыЗначенийИдентичны(ЗависимостиИсходного, ЗависимостиПроверяемого));
	
	ПриложенияИсходного = Манифест.ИсполняемыеФайлы();
	ПриложенияПрочитанного = ПрочитанныйМанифест.ИсполняемыеФайлы();
	
	юТест.ПроверитьРавенство(ПриложенияИсходного.Количество(), ПриложенияПрочитанного.Количество());
	Для Сч = 0 По ПриложенияИсходного.Количество()-1 Цикл
		юТест.ПроверитьРавенство(ПриложенияИсходного[Сч], ПриложенияПрочитанного[Сч], "Приложение в строке " + Сч);
	КонецЦикла;
	
	МодулиИсходного = Манифест.ВсеМодулиПакета();
	МодулиПрочитанного = ПрочитанныйМанифест.ВсеМодулиПакета();
	
	юТест.ПроверитьИстину(ТаблицыЗначенийИдентичны(МодулиИсходного, МодулиПрочитанного));
	
КонецПроцедуры

Функция ТаблицыЗначенийИдентичны(Знач Исходная, Знач Проверяемая)
	
	юТест.ПроверитьРавенство(Исходная.Количество(), Проверяемая.Количество(), "Количество строк должно быть равным");
	юТест.ПроверитьРавенство(Исходная.Колонки.Количество(), Проверяемая.Колонки.Количество(), "Количество колоно должно быть равным");
	
	Для Сч = 0 По Исходная.Количество()-1 Цикл
		СтрокаИсходной    = Исходная[Сч];
		СтрокаПроверяемой = Проверяемая[Сч];
		
		Для Каждого Колонка Из Исходная.Колонки Цикл
			юТест.ПроверитьРавенство(СтрокаИсходной[Колонка.Имя], СтрокаПроверяемой[Колонка.Имя], "Проверяем равенство " + Колонка.Имя + " в строке " + Сч);
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Логирование.ПолучитьЛог("oscript.app.opm").УстановитьУровень(УровниЛога.Отладка);
