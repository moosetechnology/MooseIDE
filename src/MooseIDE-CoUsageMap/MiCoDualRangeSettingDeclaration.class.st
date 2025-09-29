"
Utility class to add a dual slider (slider with two handles representing a min and a max on a scale)
"
Class {
	#name : #MiCoDualRangeSettingDeclaration,
	#superclass : #RangeSettingDeclaration,
	#instVars : [
		'dual',
		'leftText',
		'rightText'
	],
	#category : #'MooseIDE-CoUsageMap-Settings'
}

{ #category : #accessing }
MiCoDualRangeSettingDeclaration >> dmaxValue: aValue [
	self maxValue: aValue.
	dual updateValue.
	self updateText: rightText.
]

{ #category : #accessing }
MiCoDualRangeSettingDeclaration >> dminValue: aValue [
	self minValue: aValue.
	dual updateValue.
	self updateText: leftText.
]

{ #category : #'user interface' }
MiCoDualRangeSettingDeclaration >> inputWidget [
	| slider |
	dual := MiCoDualSlider new
		model: self;
		min: self range first;
		max: self range last;
		quantum: self range increment;
		getMax: #maxValue;
		setMax: #smaxValue:;
		getMin: #minValue;
		setMin: #sminValue:;
		build;
		yourself.
	slider := dual canvas createMorph.
	slider
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		setBalloonText: self description;
		minWidth: 300;
		minHeight: 26.
	leftText := (self theme 
			newTextEntryIn: self
			for: self
			get: #minValue
			set: #dminValue:
			class: SmallInteger
			getEnabled: #enabled
			help: nil)
		hResizing: #rigid;
		width: 80;
		wantsFrameAdornments: true;
		yourself.
	rightText := (self theme 
			newTextEntryIn: self
			for: self
			get: #maxValue
			set: #dmaxValue:
			class: SmallInteger
			getEnabled: #enabled
			help: nil)
		hResizing: #rigid;
		width: 80;
		wantsFrameAdornments: true;
		yourself.
	^ (self theme
		newRowIn: self
		for: { leftText. slider. rightText})
		cellInset: 10;
		yourself
]

{ #category : #accessing }
MiCoDualRangeSettingDeclaration >> maxValue [
	^ self realValue last
]

{ #category : #accessing }
MiCoDualRangeSettingDeclaration >> maxValue: aValue [
	aValue
		ifNil: [self settingReceiver perform: self setSelector with: nil]
		ifNotNil: [ | minVal maxVal |
			minVal := self realValue first.
			maxVal := aValue min: self range last max: minVal.
			self settingReceiver 
				perform: self setSelector 
				with: (minVal to: maxVal)].
]

{ #category : #accessing }
MiCoDualRangeSettingDeclaration >> minValue [
	^ self realValue first
]

{ #category : #accessing }
MiCoDualRangeSettingDeclaration >> minValue: aValue [
	aValue
		ifNil: [self settingReceiver perform: self setSelector with: nil]
		ifNotNil: [ | minVal maxVal |
			maxVal := self realValue last.
			minVal := aValue min: maxVal max: self range first.
			self settingReceiver 
				perform: self setSelector 
				with: (minVal to: maxVal)].
]

{ #category : #accessing }
MiCoDualRangeSettingDeclaration >> smaxValue: aValue [
	self maxValue: aValue.
	rightText updateTextWith: rightText getTextFromModel

]

{ #category : #accessing }
MiCoDualRangeSettingDeclaration >> sminValue: aValue [
	self minValue: aValue.
	leftText updateTextWith: leftText getTextFromModel

]

{ #category : #accessing }
MiCoDualRangeSettingDeclaration >> updateText: text [
	| string |
	string := text getTextFromModel.
	text updateTextWith: string.
	text moveCursorToIndex: string size+1.
]
