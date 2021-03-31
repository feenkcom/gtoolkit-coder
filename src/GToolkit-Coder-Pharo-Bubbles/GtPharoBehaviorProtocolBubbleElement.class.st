Class {
	#name : #GtPharoBehaviorProtocolBubbleElement,
	#superclass : #BrHorizontalPane,
	#traits : 'TGtWithPharoBehaviorProtocolCoderViewModel',
	#classTraits : 'TGtWithPharoBehaviorProtocolCoderViewModel classTrait',
	#instVars : [
		'protocolLabel',
		'methodsContainer'
	],
	#category : #'GToolkit-Coder-Pharo-Bubbles'
}

{ #category : #initialization }
GtPharoBehaviorProtocolBubbleElement >> createMethodsContainer [
	^ BrVerticalPane new
		hExact: 200;
		vFitContent;
		padding: (BlInsets all: 4)
]

{ #category : #initialization }
GtPharoBehaviorProtocolBubbleElement >> createProtocolLabel [
	^ BrLabel new
		beLargeSize;
		look: BrGlamorousLabelLook
]

{ #category : #'private - instance creation' }
GtPharoBehaviorProtocolBubbleElement >> createProtocolMethodRowFor: aPharoMethodsCoderViewModel index: anIndex [
	| tooltipLook |

	tooltipLook := BrGlamorousWithTooltipLook
		content: [
			aPharoMethodsCoderViewModel expanded: true.
			GtSourceCoderEditorElement new
				in: [ :anEditorElement | anEditorElement editor beParagraphBased ];
				textualCoderViewModel: aPharoMethodsCoderViewModel;
				vFitContent;
				hExact: 400 ].
	tooltipLook
		showDelay: 0 seconds;
		hideDelay: 0 seconds;
		attachToLeftAndRight;
		onPrimaryHover.

	^ BrLabel new
		hMatchParent;
		id: (GtPharoBehaviorProtocolBubbleMethodHeaderElementId indexed: anIndex);
		text: aPharoMethodsCoderViewModel selector;
		look: BrGlamorousLabelLook + tooltipLook + (BrStyleCommonLook new
			hovered: [ :s | s background: (Color gray alpha: 0.2) ]);
		when: BlClickEvent do: [ :anEvent |
			| aContainer aCoderElement |
			anEvent consumed: true.
			
			aContainer := self.
			aContainer removeChildNamed: #'bubble--editor'.
			
			aPharoMethodsCoderViewModel expanded: true.
			aCoderElement := aPharoMethodsCoderViewModel asElement.
			aCoderElement hExact: 500.
			aCoderElement vFitContent.
			
			aContainer addChild: (aCoderElement id: #'bubble--editor').
			self requestStyle ]
]

{ #category : #initialization }
GtPharoBehaviorProtocolBubbleElement >> initialize [
	super initialize.

	self
		background: (Color white);
		addLook: BrShadowLook new beLarge;
		addLook: BrGlamorousWithMaximizerAptitude new;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 5);
		beInSeparateCompositionLayer;
		fitContent.

	protocolLabel := self createProtocolLabel.
	protocolLabel constraintsDo: [ :c | c linear horizontal alignCenter ].
	methodsContainer := self createMethodsContainer.

	methodsContainer addChild: protocolLabel.
	
	self addChild: methodsContainer.
	
	self addLook: (BrLayoutResizerLook new
		vFitContentToFitContent: [ :aBlock |
			self
				childWithId: #'bubble--editor'
				ifFound: aBlock
				ifNone: [  ] ];
		hFitContent: [ :aBlock |
			self
				childWithId: #'bubble--editor'
				ifFound: aBlock
				ifNone: [  ] ]
		toExact: 500;
		exactToMatchParent: [ :aBlock |
			self
				childWithId: #'bubble--editor'
				ifFound: aBlock
				ifNone: [  ] ];
		matchParentToMatchParent: [ :aBlock |
			self
				childWithId: #'bubble--editor'
				ifFound: aBlock
				ifNone: [  ] ])
]

{ #category : #'api - pharo behavior protocol coder view model' }
GtPharoBehaviorProtocolBubbleElement >> onPharoBehaviorProtocolCoderViewModelChanged [
	"Is sent when a new pharoBehaviorProtocolCoder view model is assigned to the element.
	Note: #onPharoBehaviorProtocolCoderViewModelChanged is sent before #subscribeToPharoBehaviorProtocolCoderViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostPharoBehaviorProtocolCoderViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"

	protocolLabel text: self pharoBehaviorProtocolCoderViewModel protocol.

	methodsContainer removeChildren: (methodsContainer query // GtPharoBehaviorProtocolBubbleMethodHeaderElementId) all.
	methodsContainer addChildren: (self pharoBehaviorProtocolCoderViewModel methodViewModels
		collectWithIndex: [ :eachMethodViewModel :anIndex | self createProtocolMethodRowFor: eachMethodViewModel index: anIndex ]).
		
	((self pharoBehaviorProtocolCoderViewModel protocol beginsWith: 'private')
		or: [ (self pharoBehaviorProtocolCoderViewModel protocol beginsWith: '*') ])
		ifTrue: [ self background: BrGlamorousColors backdropColor ]
		ifFalse: [ self background: Color white ]
]
