Class {
	#name : #MiModelDashboard,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'mainPresenter'
	],
	#category : #'MooseIDE-Core-ModelDashboard'
}

{ #category : #'world menu' }
MiModelDashboard class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiModelDashboard class >> menuItem [

	^#ModelDashboardBrowser
]

{ #category : #'world menu' }
MiModelDashboard class >> menuPriority [

	^ self menuMetaToolsPriority + 1
]

{ #category : #'world menu' }
MiModelDashboard class >> newModel [

	^ MiModelDashboardModel new
]

{ #category : #'world menu' }
MiModelDashboard class >> open [
	<script>
	^ super open
]

{ #category : #'world menu' }
MiModelDashboard class >> title [
	^ 'Model Dashboard'
]

{ #category : #testing }
MiModelDashboard >> canFollowEntity: anObject [

	^anObject isMooseModel 
]

{ #category : #testing }
MiModelDashboard >> canPropagate [

	^ false
]

{ #category : #testing }
MiModelDashboard >> canTagEntities [

	^ false
]

{ #category : #testing }
MiModelDashboard >> followEntity: anEntity [

	super followEntity: anEntity.
	specModel followEntity: anEntity
]

{ #category : #testing }
MiModelDashboard >> initializePresenters [

	mainPresenter := self newText
]

{ #category : #testing }
MiModelDashboard >> miSelectedItem [

	^#()
]

{ #category : #actions }
MiModelDashboard >> updateReport: report [

	mainPresenter text: report
]
