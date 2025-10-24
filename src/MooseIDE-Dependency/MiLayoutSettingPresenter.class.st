Class {
	#name : 'MiLayoutSettingPresenter',
	#superclass : 'MiAbstractRadioButtonSettingPresenter',
	#category : 'MooseIDE-Dependency-ArchitecturalMap',
	#package : 'MooseIDE-Dependency',
	#tag : 'ArchitecturalMap'
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
MiLayoutSettingPresenter >> addButtons: aCollection [

	self layout addPresenters: aCollection withConstraints: [ :c | c width: 75 ]
]

{ #category : 'layout' }
MiLayoutSettingPresenter >> defaultLayout [

	^ MiMultipleRowsLayout new
]

{ #category : 'building' }
MiLayoutSettingPresenter >> helpForItem: aLayout [

	^ aLayout layoutDescription
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
