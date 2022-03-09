"
This browser is to see dependencies between methods and attributes and mark them with tags
"
Class {
	#name : #MiCoUsageBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'coUsageMap',
		'classModel'
	],
	#category : #'MooseIDE-CoUsageMap-Browser'
}

{ #category : #layout }
MiCoUsageBrowser class >> defaultLayout [
	^ SpBoxLayout newLeftToRight
		add: #coUsageMap;
		yourself
]

{ #category : #'world menu' }
MiCoUsageBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	^(aBuilder item: #FilesBrowser)
		parent: self midasBrowserMenuLabel;
		label: self title;
		help: self helpMessage;
		order: 5;
		action: [ self open ] ;
		yourself
]

{ #category : #'instance creation' }
MiCoUsageBrowser class >> open [
	<script>
	^ super open
]

{ #category : #accessing }
MiCoUsageBrowser class >> title [ 
	^ 'Co Usage Map'
]

{ #category : #accessing }
MiCoUsageBrowser class >> windowSize [
	^ 800@600
]

{ #category : #testing }
MiCoUsageBrowser >> browserClosed [

	super browserClosed.
	application unregisterConsumer: coUsageMap.
	application unregisterProducer: coUsageMap
]

{ #category : #testing }
MiCoUsageBrowser >> canFollowEntity: anEntity [
	^ anEntity isClass
]

{ #category : #accessing }
MiCoUsageBrowser >> classModel [

	^ classModel
]

{ #category : #accessing }
MiCoUsageBrowser >> classModel: anObject [
	classModel := anObject
]

{ #category : #actions }
MiCoUsageBrowser >> followEntity: anEntity [
	classModel := anEntity.
	coUsageMap run
]

{ #category : #testing }
MiCoUsageBrowser >> hasSettings [ 
	^true
]

{ #category : #initialization }
MiCoUsageBrowser >> initializePresenters [

	coUsageMap := self instantiate: MiCoUsageMapVisualization.
	application registerConsumer: coUsageMap for: FamixTag.
	application registerConsumer: coUsageMap for: FamixTagAssociation.
	application registerProducer: coUsageMap for: FamixTagAssociation.
]

{ #category : #actions }
MiCoUsageBrowser >> miSelectedItem [

	^ classModel
]

{ #category : #actions }
MiCoUsageBrowser >> settings [ 
	coUsageMap openSettingsBrowser
]
