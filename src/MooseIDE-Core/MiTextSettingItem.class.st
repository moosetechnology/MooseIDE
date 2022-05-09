Class {
	#name : #MiTextSettingItem,
	#superclass : #MiAbstractSettingItem,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #tests }
MiTextSettingItem >> getValue [

	^ presenter text
]

{ #category : #initialization }
MiTextSettingItem >> initialize [

	super initialize.
	presenter := SpTextPresenter new
		help: help ;
		yourself
]

{ #category : #tests }
MiTextSettingItem >> setValue: aText [

	presenter text: aText
]
