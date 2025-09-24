Class {
	#name : 'MiModelReportSettingsConfiguration',
	#superclass : 'MiAbstractSettingsConfiguration',
	#instVars : [
		'largeClassThreshold',
		'longClassThreshold',
		'dataClassThreshold',
		'longMethodThreshold',
		'complexMethodThreshold',
		'excessiveAPIThreshold'
	],
	#category : 'MooseIDE-Core-Reporter',
	#package : 'MooseIDE-Core-Reporter'
}

{ #category : 'accessing' }
MiModelReportSettingsConfiguration >> complexMethodThreshold [

	^ complexMethodThreshold
]

{ #category : 'accessing' }
MiModelReportSettingsConfiguration >> complexMethodThreshold: anObject [

	complexMethodThreshold := anObject
]

{ #category : 'accessing' }
MiModelReportSettingsConfiguration >> dataClassThreshold [

	^ dataClassThreshold
]

{ #category : 'accessing' }
MiModelReportSettingsConfiguration >> dataClassThreshold: anObject [

	dataClassThreshold := anObject
]

{ #category : 'accessing' }
MiModelReportSettingsConfiguration >> excessiveAPIThreshold [

	^ excessiveAPIThreshold
]

{ #category : 'accessing' }
MiModelReportSettingsConfiguration >> excessiveAPIThreshold: anObject [

	excessiveAPIThreshold := anObject
]

{ #category : 'accessing' }
MiModelReportSettingsConfiguration >> largeClassThreshold [

	^ largeClassThreshold
]

{ #category : 'accessing' }
MiModelReportSettingsConfiguration >> largeClassThreshold: anObject [

	largeClassThreshold := anObject
]

{ #category : 'accessing' }
MiModelReportSettingsConfiguration >> longClassThreshold [

	^ longClassThreshold
]

{ #category : 'accessing' }
MiModelReportSettingsConfiguration >> longClassThreshold: anObject [

	longClassThreshold := anObject
]

{ #category : 'accessing' }
MiModelReportSettingsConfiguration >> longMethodThreshold [

	^ longMethodThreshold
]

{ #category : 'accessing' }
MiModelReportSettingsConfiguration >> longMethodThreshold: anObject [

	longMethodThreshold := anObject
]

{ #category : 'ui' }
MiModelReportSettingsConfiguration >> settingsPresenters [

	^ OrderedCollection new
		  add: ((MiNumberSettingPresenter on: self)
				   number: largeClassThreshold;
				   unit: 'nb of methods';
				   label: 'Large class threshold:';
				   help:
					   'Above this number of methods, a class is considered large';
				   yourself);
		  add: ((MiNumberSettingPresenter on: self)
				   number: longClassThreshold;
				   unit: 'LOC';
				   label: 'Long class threshold:';
				   help:
					   'Above this number of lines of code, a class is considered long';
				   yourself);
		  add: ((MiNumberSettingPresenter on: self)
				   number: dataClassThreshold;
				   unit: 'nb of attributes';
				   label: 'Data class threshold:';
				   help:
					   'Above this number of attribute, a class is considered to be a Data class';
				   yourself);
		  add: ((MiNumberSettingPresenter on: self)
				   number: longMethodThreshold;
				   unit: 'LOC';
				   label: 'Long method threshold:';
				   help:
					   'Above this number of lines of code, a method is considered long';
				   yourself);
		  add: ((MiNumberSettingPresenter on: self)
				   number: complexMethodThreshold;
				   unit: 'cyclomatic complexity';
				   label: 'Complex method threshold:';
				   help:
					   'Above this cyclomatic complexity, a method is considered complex';
				   yourself);
		  add: ((MiNumberSettingPresenter on: self)
				   number: excessiveAPIThreshold;
				   unit: 'nb of parameters';
				   label: 'Excessive API threshold:';
				   help:
					   'Above this number of parameters, a method is considered to have an excessive API';
				   yourself);
		  yourself
]
