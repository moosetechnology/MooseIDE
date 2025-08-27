Class {
	#name : 'MiLayoutSettingPresenter',
	#superclass : 'MiAbstractRadioButtonSettingPresenter',
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'accessing' }
MiLayoutSettingPresenter class >> help [

	^ 'The layout used to display entities'
]

{ #category : 'accessing' }
MiLayoutSettingPresenter class >> label [

	^ 'Entities layout'
]

{ #category : 'event handling' }
MiLayoutSettingPresenter >> activate: aLayout [

	memento layout: aLayout
]

{ #category : 'building' }
MiLayoutSettingPresenter >> helpForItem: aLayout [

	^ aLayout layoutDescription
]

{ #category : 'testing' }
MiLayoutSettingPresenter >> isCurrentValue: aLayout [

	^ aLayout = memento layout
]

{ #category : 'accessing' }
MiLayoutSettingPresenter >> items [

	^ memento availableLayouts
]

{ #category : 'building' }
MiLayoutSettingPresenter >> labelForItem: aLayout [

	^ aLayout layoutName
]
