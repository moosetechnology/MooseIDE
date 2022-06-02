"
I am a setting item which open a color picker to set a color.
"
Class {
	#name : #MiColorSettingItem,
	#superclass : #MiAbstractSettingItem,
	#instVars : [
		'colorPicker'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #accessing }
MiColorSettingItem >> getValue [

	^ self presenter canvas color
]

{ #category : #initialization }
MiColorSettingItem >> initialize [

	super initialize.
	colorPicker := MiColorPicker new "whenColorChangedDo: [ :c | 
		               presenter canvas color: c ]".
	presenter := SpRoassalPresenter new.
	presenter canvas
		when: RSMouseLeftClick
		send: #openColorPicker
		to: self.
	label := 'Choose color'
]

{ #category : #accessing }
MiColorSettingItem >> openColorPicker [

	| modal |
	colorPicker setColor: self getValue.
	modal := colorPicker asModalWindow.
	modal initialExtent: 260 @ 450.
	modal okAction: [ self setValue: colorPicker color ].
	modal open
]

{ #category : #accessing }
MiColorSettingItem >> setValue: aColor [

	self presenter canvas color: aColor.
	self presenter canvas signalUpdate
]
