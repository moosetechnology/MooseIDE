"
utility class to create a new widged made in roassal. This widget is used in SystemSettings
"
Class {
	#name : #MiCoRangeSettingDeclaration,
	#superclass : #RangeSettingDeclaration,
	#category : #'MooseIDE-CoUsageMap-Slider'
}

{ #category : #'user interface' }
MiCoRangeSettingDeclaration >> inputWidget [
	| slider |
	slider := MiCoSlider new
		model: self;
		min: self range first;
		max: self range max;
		quantum: self range increment;
		getValueSelector: #realValue;
		setValueSelector: #realValue:;
		build;
		yourself.
	slider := slider canvas createMorph.
	slider
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		setBalloonText: self description;
		minWidth: 300;
		height: 20.
	
	^ (self theme
		newRowIn: self
		for: {
			(self theme 
				newTextEntryIn: self
				for: self
				get: #realValue
				set: #realValue:
				class: (Smalltalk globals at: self type)
				getEnabled: #enabled
				help: nil)
					hResizing: #rigid;
					width: 80;
					wantsFrameAdornments: true;
					yourself.
				slider}) 
		cellInset: 10;
		yourself
]
