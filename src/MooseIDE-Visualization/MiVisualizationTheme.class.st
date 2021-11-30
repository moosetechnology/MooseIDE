Class {
	#name : #MiVisualizationTheme,
	#superclass : #Object,
	#instVars : [
		'iconTheme'
	],
	#category : #'MooseIDE-Visualization'
}

{ #category : #initialization }
MiVisualizationTheme >> defaultIconTheme [
	{  
		FamixTClass -> #famixClass .
		FamixTMethod -> #famixMethod .
		FamixTNamespace -> #famixNamespace .
		FamixTAttribute -> #famixAttribute .
		FamixTAnnotationInstance -> #famixAnnotationInstance .
		FamixTAnnotationType -> #famixAnnotationType .
		FamixTFunction -> #famixFunction .
		MooseEntity -> #mooseIcon
	} do: [:assoc | iconTheme at: assoc key put: assoc value ]
]

{ #category : #initialization }
MiVisualizationTheme >> initialize [
	super initialize.
	
	iconTheme := Dictionary new.
	self defaultIconTheme
]

{ #category : #running }
MiVisualizationTheme >> mooseIconNameFor: anEntity [
	self flag: 'should use double dispatch instead of #iskindof:'.
	
	iconTheme keysAndValuesDo: [ :k :v |
		(anEntity class usesTrait: k) ifTrue: [ ^ v ]
	].
	^nil
]
