Class {
	#name : #GtSourceCoderCollapsedContentElement,
	#superclass : #GtSourceCoderContentElement,
	#instVars : [
		'label',
		'addOns',
		'content'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #initialization }
GtSourceCoderCollapsedContentElement >> initialize [
	super initialize.
	
	content := BlElement new
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].

	label := self newLabel.
	addOns := self newAddOnsContainer.

	content addChildren: { label. addOns }.
	self addChild: content
]

{ #category : #'instance creation' }
GtSourceCoderCollapsedContentElement >> newAddOnsContainer [
	^ BrFromPromise new
		fitContent;
		stencil: [
			BrHorizontalPane new
				fitContent;
				margin: (BlInsets top: 4 left: 1 bottom: 1 right: 1) ];
		dataBinder: [ :anAddOnsContainer :aData |
			anAddOnsContainer removeChildren.
			aData
				ifSuccess: [ :theAddOns |
					theAddOns previews do: [ :eachAddOn |
						(eachAddOn stencilBuilder 
							coderUIModel: textualCoderViewModel;
							build) ifNotNil: [ :eachAddOnStencil |
								anAddOnsContainer addChild: eachAddOnStencil asElement ] ] ]
				ifError: [ :anError | anAddOnsContainer addChild: (BrLabel new aptitude: BrGlamorousLabelAptitude; text: anError printString) ]
				ifPending: [  ] ]
]

{ #category : #'instance creation' }
GtSourceCoderCollapsedContentElement >> newLabel [
	^ BrFromPromise new
		fitContent;
		stencil: [
			BlAttributedTextElement new
				id: #label;
				editorMeasurement;
				bold;
				glamorousCodeFont ];
		dataBinder: [ :aLabel :aData |
			aData
				ifSuccess: [ :aText | aLabel text: aText asRopedText ]
				ifError: [ :anError | aLabel text: anError printString asRopedText ]
				ifPending: [ aLabel text: '' asRopedText ] ]
]

{ #category : #'api - textual coder view model' }
GtSourceCoderCollapsedContentElement >> onTextualCoderViewModelChanged [
	super onTextualCoderViewModelChanged.
	
	label promise: textualCoderViewModel coderModel collapsedTextPromise.
	addOns promise: textualCoderViewModel addOns
]
