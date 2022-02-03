"
This browser is to see dependencies between methods and attributes and mark them with tags
"
Class {
	#name : #MiCoUsageBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'coUsageMap',
		'classModel',
		'coUsageMapSettings'
	],
	#category : #'MooseIDE-CoUsageMap-Browser'
}

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

{ #category : #initialization }
MiCoUsageBrowser >> initializeLayout [

	self layout: (SpBoxLayout newLeftToRight
			 spacing: 3;
			 add: coUsageMapSettings width: 250;
			 add: coUsageMap;
			 yourself)
]

{ #category : #initialization }
MiCoUsageBrowser >> initializePresenters [

	coUsageMap := self instantiate: MiCoUsageMapVisualization.
	application registerConsumer: coUsageMap for: FamixTag.
	application registerProducer: coUsageMap for: FamixTagAssociation.
	coUsageMapSettings := self instantiate: MiCoUsageMapSettings.
	self initializeLayout
]

{ #category : #actions }
MiCoUsageBrowser >> miSelectedItem [

	^ classModel
]
