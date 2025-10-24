Class {
	#name : 'MiLayoutSettingPresenter',
	#superclass : 'MiAbstractRadioButtonSettingPresenter',
	#category : 'MooseIDE-ArchitecturalMap',
	#package : 'MooseIDE-ArchitecturalMap'
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

	configuration layout: aLayout
]

{ #category : 'adding' }
MiLayoutSettingPresenter >> addButton: button toRow: aBoxLayout [

	aBoxLayout add: button width: 75
]

{ #category : 'building' }
MiLayoutSettingPresenter >> helpForItem: aLayout [

	^ aLayout layoutDescription
]

{ #category : 'initialization' }
MiLayoutSettingPresenter >> initialize [

	super initialize.

	self beMultipleRows
]

{ #category : 'testing' }
MiLayoutSettingPresenter >> isCurrentValue: aLayout [

	^ aLayout = configuration layout
]

{ #category : 'accessing' }
MiLayoutSettingPresenter >> items [

	^ configuration availableLayouts
]

{ #category : 'building' }
MiLayoutSettingPresenter >> labelForItem: aLayout [

	^ aLayout layoutName
]
