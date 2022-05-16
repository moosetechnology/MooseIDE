"
A settingItem which value is given in a textField.
It has a convertion block to convert from the textField to the actual type of the value
"
Class {
	#name : #MiTextSettingItem,
	#superclass : #MiAbstractSettingItem,
	#instVars : [
		'valueFromString'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #convertion }
MiTextSettingItem >> dateValue [
	"converter form the displayed text to a Date"
	valueFromString := [ :aString | Date fromString: aString ]
]

{ #category : #convertion }
MiTextSettingItem >> floatValue [
	"converter form the displayed text to a float"
	valueFromString := [ :aString | Float readFrom: aString]
]

{ #category : #accessing }
MiTextSettingItem >> getValue [

	^ valueFromString value: presenter text
]

{ #category : #initialization }
MiTextSettingItem >> initialize [

	super initialize.
	presenter := SpTextPresenter new
		help: help ;
		yourself.
	self stringValue
]

{ #category : #convertion }
MiTextSettingItem >> integerValue [
	"converter form the displayed text to an integer"
	valueFromString := #asInteger
]

{ #category : #accessing }
MiTextSettingItem >> setValue: anObject [

	presenter text: (displayBlock value: anObject)
]

{ #category : #convertion }
MiTextSettingItem >> stringValue [
	"converter form the displayed text to a string"
	valueFromString := #yourself
]

{ #category : #convertion }
MiTextSettingItem >> valueFromString: aBlock [
	"aBlock with one argument (a string) used to convert the text in the presenter to 
	 a value with the right type.
	There are some default setters: #floatValue, #integerValue, #dateValue, #stringValue"
	valueFromString := aBlock 
]
