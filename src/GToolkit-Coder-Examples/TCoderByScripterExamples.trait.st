Trait {
	#name : #TCoderByScripterExamples,
	#category : #'GToolkit-Coder-Examples-By scripter'
}

{ #category : #utilities }
TCoderByScripterExamples >> openAndClickOnContextMenuItemFor: aScripterOrStep id: aBlElementId [
	<gtExample>
	aScripterOrStep secondaryClickStep: [:s | 
		s label: 'Open context menu';
		// GtSourceCoderEditorId].
		
	aScripterOrStep do
		label: 'Scroll to ', aBlElementId asSymbol;
		block: [ :aList | aList scrollToItemSuchThat: [ :each | 
			each id asBlocElementId = aBlElementId asBlocElementId ] ];
		onSpaceRoot;
		// BrAnchoredOuterContainer;
		onThisOrBreadthFirstChildOfKind: BrList;
		play.

	aScripterOrStep mouseMoveOverStep: [:s | 
		s label: 'Hover ' , aBlElementId asSymbol;
		onSpaceRoot;
		// aBlElementId].

	aScripterOrStep clickStep: [:s | 
		s label: 'Click ' , aBlElementId asSymbol;
		onSpaceRoot;
		// aBlElementId]
]

{ #category : #'examples - scripter' }
TCoderByScripterExamples >> scripter [
	| scripter |
	scripter := BlScripter new.
	
	self assert: scripter events isEmpty.
	
	^ scripter
]

{ #category : #utilities }
TCoderByScripterExamples >> scripterForBlock: aBlock [
	<gtExample>
	| aScripter |
	aScripter := self scripter.
	aScripter substep: 'Initialize Coder Model and UI' do: [ :aStep | 
		aStep set 
			label: 'Initialize Coder Model';
			model: aBlock;
			play.
		aStep set 
			label: 'Initialize Coder UI';
			element: [ :aCoder | aCoder asElement ];
			onModel;
			play ].

	^ aScripter
]

{ #category : #utilities }
TCoderByScripterExamples >> scripterInPagerForBlock: aBlock [
	<gtExample>
	| aScripter |
	aScripter := self scripter.
	aScripter substep: 'Initialize Coder Model and UI' do: [ :aStep | 
		aStep set 
			label: 'Initialize Coder Model';
			model: aBlock;
			play.
		aStep set 
			label: 'Initialize Coder UI';
			element: [ :aCoder |
				GtPager createWrappedOn: aCoder asElement ];
			onModel;
			play ].

	^ aScripter
]

{ #category : #utilities }
TCoderByScripterExamples >> selectTextFor: aScripterOrStep from: aStartPosition to: aToPosition andCheck: aSelectedString [
	<gtExample>
	aScripterOrStep doStep: [:s | 
		s label: 'Select part of the method';
		// GtSourceCoderEditorId;
		action: [ :aSourceEditor | 
			aSourceEditor selecter
				from: aStartPosition to: aToPosition;
				select ]].

	aScripterOrStep assertStep: [:s | 
		s label: 'Assert selected text';
		// GtSourceCoderEditorId;
		value: [ :aSourceEditor | aSourceEditor editor selectedText asString ]
			equals: aSelectedString]
]
