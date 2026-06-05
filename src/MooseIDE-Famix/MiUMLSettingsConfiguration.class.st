Class {
	#name : 'MiUMLSettingsConfiguration',
	#superclass : 'MiAbstractSettingsConfiguration',
	#instVars : [
		'showAttributes',
		'showMethods'
	],
	#category : 'MooseIDE-Famix-UML',
	#package : 'MooseIDE-Famix',
	#tag : 'UML'
}

{ #category : 'ui' }
MiUMLSettingsConfiguration >> settingsPresenters [

	^ OrderedCollection
		  with: ((MiBooleanSettingPresenter on: self)
				   label: 'Show attributes';
				   help: 'Show instance variables of each class in the diagram.';
				   state: showAttributes;
				   whenStateChangedDo: [ :boolean | self showAttributes: boolean ];
				   yourself)
		  with: ((MiBooleanSettingPresenter on: self)
				   label: 'Show methods';
				   help: 'Show methods of each class in the diagram.';
				   state: showMethods;
				   whenStateChangedDo: [ :boolean | self showMethods: boolean ];
				   yourself)
]

{ #category : 'accessing' }
MiUMLSettingsConfiguration >> showAttributes [

	^ showAttributes
]

{ #category : 'accessing' }
MiUMLSettingsConfiguration >> showAttributes: aBoolean [

	showAttributes := aBoolean
]

{ #category : 'accessing' }
MiUMLSettingsConfiguration >> showMethods [

	^ showMethods
]

{ #category : 'accessing' }
MiUMLSettingsConfiguration >> showMethods: aBoolean [

	showMethods := aBoolean
]
