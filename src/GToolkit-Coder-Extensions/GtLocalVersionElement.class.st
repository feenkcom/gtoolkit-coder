Class {
	#name : #GtLocalVersionElement,
	#superclass : #BrVerticalFlow,
	#instVars : [
		'localVersion',
		'expander',
		'header',
		'content'
	],
	#category : #'GToolkit-Coder-Extensions'
}

{ #category : #accessing }
GtLocalVersionElement >> content [

	^ content
]

{ #category : #accessing }
GtLocalVersionElement >> content: anObject [

	content := anObject
]

{ #category : #accessing }
GtLocalVersionElement >> expander [

	^ expander
]

{ #category : #accessing }
GtLocalVersionElement >> expander: anObject [

	expander := anObject
]

{ #category : #accessing }
GtLocalVersionElement >> header [

	^ header
]

{ #category : #accessing }
GtLocalVersionElement >> header: anObject [

	header := anObject
]

{ #category : #accessing }
GtLocalVersionElement >> initialize [
	super initialize.

	self hMatchParent vFitContent padding: (BlInsets all: 2).

	self initializeHeader.
	self initializeContent.
	self initializeExpander.

	self addChild: self expander
]

{ #category : #accessing }
GtLocalVersionElement >> initializeContent [
	content := BrVerticalFlow new matchParent
]

{ #category : #accessing }
GtLocalVersionElement >> initializeExpander [
	expander := BrExpander new hMatchParent vFitContent
			aptitude: GtCoderExpanderAptitude new;
			header: [ self header ];
			content: [ self content ]
]

{ #category : #accessing }
GtLocalVersionElement >> initializeHeader [
	header := BrHorizontalFlow new matchParent
]

{ #category : #accessing }
GtLocalVersionElement >> localVersion: aLocalVersion [
	localVersion := aLocalVersion.
	self updateView
]

{ #category : #accessing }
GtLocalVersionElement >> updateContent [
	| currentContent previousContent change styler |
	previousContent := localVersion previousSourceCode.
	currentContent := localVersion sourceCode.

	content removeChildren.

	change := GtDiffBuilder
			computeDifferencesFrom: previousContent 
			to: currentContent
			using: GtSmaCCDiffSplitter forPharo.
	styler := GtCodeDiffRBTextStyler new.

	content
		addChild: (BrLabel new
				aptitude: BrGlamorousLabelAptitude;
				text: 'Version at ' , localVersion timeStamp printToSeconds);
		addChild: (GtDiffElementWithLabelStencil new
				fromLabelText: 'Previous';
				toLabelText: 'Changed';
				change: change;
				styler: styler) create;
		addChild: (BrFrame new
			fitContent;
			padding: (BlInsets left: 5);
			addChild: (BrButton new
				icon: BrGlamorousVectorIcons accept;
				label: 'Use this version';
				aptitude: BrGlamorousButtonWithIconAptitude;
				action: [ :aButton | localVersion loadChange ]))
]

{ #category : #accessing }
GtLocalVersionElement >> updateHeader [
	header removeChildren.
	header
		addChild: (BrLabel new
				aptitude: BrGlamorousLabelAptitude;
				text: 'Version at ' , localVersion timeStamp printToSeconds)
]

{ #category : #accessing }
GtLocalVersionElement >> updateView [
	self updateHeader.
	self updateContent.
]
