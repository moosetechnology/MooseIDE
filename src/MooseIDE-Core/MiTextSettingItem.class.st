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
	valueFromString := [ :aString | Date fromString: aString ]
]

{ #category : #convertion }
MiTextSettingItem >> floatValue [
	valueFromString := [ :aString | Float readFrom: aString]
]

{ #category : #tests }
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
	valueFromString := #asInteger
]

{ #category : #tests }
MiTextSettingItem >> setValue: anObject [

	presenter text: anObject asString
]

{ #category : #convertion }
MiTextSettingItem >> stringValue [
	valueFromString := #yourself
]

{ #category : #convertion }
MiTextSettingItem >> valueFromString: aBlock [
	"aBlock with one argument (a string) used to convert the text in the presenter in 
	 a value with the right type.
	There are some default setters: #floatValue, #integerValue, #dateValue, #stringValue"
	valueFromString := aBlock 
]
