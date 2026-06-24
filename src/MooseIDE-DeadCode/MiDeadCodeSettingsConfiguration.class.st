Class {
	#name : 'MiDeadCodeSettingsConfiguration',
	#superclass : 'MiAbstractSettingsConfiguration',
	#instVars : [
		'availableRewriters',
		'defaultRewriterClass',
		'rewriterClass'
	],
	#category : 'MooseIDE-DeadCode-Model',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Model'
}

{ #category : 'accessing' }
MiDeadCodeSettingsConfiguration >> availableRewriters [

	^ availableRewriters
]

{ #category : 'accessing' }
MiDeadCodeSettingsConfiguration >> availableRewriters: anObject [

	availableRewriters := anObject
]

{ #category : 'accessing' }
MiDeadCodeSettingsConfiguration >> defaultRewriterClass [

	^ defaultRewriterClass
]

{ #category : 'accessing' }
MiDeadCodeSettingsConfiguration >> defaultRewriterClass: anObject [

	defaultRewriterClass := anObject
]

{ #category : 'accessing' }
MiDeadCodeSettingsConfiguration >> rewriterClass [

	^ rewriterClass
]

{ #category : 'accessing' }
MiDeadCodeSettingsConfiguration >> rewriterClass: anObject [

	rewriterClass := anObject
]

{ #category : 'ui' }
MiDeadCodeSettingsConfiguration >> settingsPresenters [

	^ OrderedCollection with: ((MiDroplistSettingPresenter on: self)
		label: 'Width metric:' ;
		help: 'Rewriter to apply on dead entities (eg. delete them, or commented them out)' ;
		items: availableRewriters ;
		selectItem: defaultRewriterClass ;
		display: [ :rewriter | rewriter commandLabel ] ;
		whenSelectedDo: [ :selectedRewriterClass | rewriterClass := selectedRewriterClass ] ;
		yourself)
]
