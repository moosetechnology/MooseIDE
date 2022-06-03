"
A MiSettingItem which value is given by a checkbox (therefore: true or false setting)
"
Class {
	#name : #MiCheckboxSettingItem,
	#superclass : #MiAbstractSettingItem,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #accessing }
MiCheckboxSettingItem >> getValue [

	^presenter state
]

{ #category : #initialization }
MiCheckboxSettingItem >> initialize [ 
	super initialize.

	presenter := SpCheckBoxPresenter new
]

{ #category : #accessing }
MiCheckboxSettingItem >> setValue: aBoolean [

	presenter state: aBoolean 
]
