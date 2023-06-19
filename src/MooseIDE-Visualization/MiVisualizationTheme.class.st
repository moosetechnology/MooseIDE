Class {
	#name : #MiVisualizationTheme,
	#superclass : #Object,
	#instVars : [
		'iconTheme'
	],
	#category : #'MooseIDE-Visualization-Helpers'
}

{ #category : #initialization }
MiVisualizationTheme >> defaultIconTheme [
	^{  
		FamixTClass -> #famixClass .
		FamixTMethod -> #famixMethod .
		FamixTNamespace -> #famixNamespace .
		FamixTAttribute -> #famixAttribute .
		FamixTAnnotationInstance -> #famixAnnotationInstance .
		FamixTAnnotationType -> #famixAnnotationType .
		FamixTFunction -> #famixFunction .
		MooseEntity -> #mooseIcon
	}
]

{ #category : #accessing }
MiVisualizationTheme >> iconTheme [

	^ iconTheme
]

{ #category : #accessing }
MiVisualizationTheme >> iconTheme: anObject [

	iconTheme := anObject
]

{ #category : #initialization }
MiVisualizationTheme >> initialize [
	super initialize.
	
	self iconTheme: self defaultIconTheme
]

{ #category : #api }
MiVisualizationTheme >> mooseIconNameFor: anEntity [
	| usedTraits |
	self flag: 'should find a better way to match traits to icon (some kind of double dispatch?)'.
	usedTraits := anEntity class allTraits.
	iconTheme do: [:assoc |
		(usedTraits includes: assoc key) ifTrue: [ ^assoc value ]
	].
	^nil
]
