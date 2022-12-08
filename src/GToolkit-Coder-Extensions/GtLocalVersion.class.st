Class {
	#name : #GtLocalVersion,
	#superclass : #BrVerticalFlow,
	#instVars : [
		'localVersion',
		'compiledMethod',
		'expander',
		'header',
		'content'
	],
	#category : #'GToolkit-Coder-Extensions'
}

{ #category : #accessing }
GtLocalVersion >> compiledMethod [

	^ compiledMethod
]

{ #category : #accessing }
GtLocalVersion >> compiledMethod: anObject [

	compiledMethod := anObject
]

{ #category : #accessing }
GtLocalVersion >> content [

	^ content
]

{ #category : #accessing }
GtLocalVersion >> content: anObject [

	content := anObject
]

{ #category : #accessing }
GtLocalVersion >> expander [

	^ expander
]

{ #category : #accessing }
GtLocalVersion >> expander: anObject [

	expander := anObject
]

{ #category : #accessing }
GtLocalVersion >> header [

	^ header
]

{ #category : #accessing }
GtLocalVersion >> header: anObject [

	header := anObject
]

{ #category : #accessing }
GtLocalVersion >> initialize [
	super initialize.

	self hMatchParent vFitContent padding: (BlInsets all: 2).

	self initializeHeader.
	self initializeContent.
	self initializeExpander.

	self addChild: self expander
]

{ #category : #accessing }
GtLocalVersion >> initializeContent [
	content := BrVerticalFlow new matchParent
]

{ #category : #accessing }
GtLocalVersion >> initializeExpander [
	expander := BrExpander new hMatchParent vFitContent
			aptitude: GtCoderExpanderAptitude new;
			header: [ self header ];
			content: [ self content ]
]

{ #category : #accessing }
GtLocalVersion >> initializeHeader [
	header := BrHorizontalFlow new matchParent
]

{ #category : #accessing }
GtLocalVersion >> localVersion: aLocalVersion [
	localVersion := aLocalVersion.
	self updateView
]

{ #category : #accessing }
GtLocalVersion >> updateContent [
	| previousContent newContent |
	previousContent := compiledMethod sourceCode.
	newContent := localVersion sourceCode.


	content
		addChild: (BrLabel new
				aptitude: BrGlamorousLabelAptitude;
				text: 'Version at ' , localVersion timeStamp printToSeconds);
		addChild: (GtDiffElementWithLabelStencil new
				fromLabelText: 'Current';
				toLabelText: 'Version';
				diffBuilder: ((GtCodeDiffBuilder from: previousContent to: newContent) isMethod: true))
				create;
		addChild: (BrFrame new
				addChild: (BrButton new
						icon: BrGlamorousVectorIcons accept;
						label: 'Use this version';
						aptitude: BrGlamorousButtonWithIconAptitude;
						action: [ :aButton | localVersion asMCMethodDefinition load ]))
]

{ #category : #accessing }
GtLocalVersion >> updateHeader [
	header
		addChild: (BrLabel new
				aptitude: BrGlamorousLabelAptitude;
				text: 'Version at ' , localVersion timeStamp printToSeconds)
]

{ #category : #accessing }
GtLocalVersion >> updateView [
	self updateHeader.
	self updateContent.
]
