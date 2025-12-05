Trait {
	#name : #TCoderByScripterExamples,
	#category : #'GToolkit-Coder-Examples-Scripter'
}

{ #category : #utilities }
TCoderByScripterExamples >> openAndClickOnContextMenuItemFor: aScripterOrStep id: aBlElementId [
	<gtExample>
	aScripterOrStep secondaryClickStep: [:s | 
		s label: 'Open context menu';
		// GtSourceCoderEditorId].
		
	aScripterOrStep do
		label: 'Scroll to ', aBlElementId asSymbol;
		block: [ :aList | 
			(aList isKindOf: BrUngroupedList) 
				ifTrue: [
					aList scrollToItemSuchThat: [ :each | 
						each id asBlocElementId = aBlElementId asBlocElementId ] ]
				ifFalse: [ 
					| aQuery anAttemptCount |
					anAttemptCount := 0.
					[
						| isVisible |
						aQuery := aList query // aBlElementId asBlocElementId.
						isVisible := aQuery isEmpty not and: [
							aQuery anyOne isVisibleFullyInParent: aList ].
						anAttemptCount < 5 and: [ isVisible not ]
					] whileTrue: [ 
						aList scrollBy: 0 @ 100.
						anAttemptCount := anAttemptCount + 1.
					].
					self 
						assert: aQuery isEmpty not 
						description: [ 'Grouped list {2} does not include {2} element id'
							format: { aList. aBlElementId } ]
					 ] ];
		onSpaceRoot;
		// BrMenuSteppedElement;
		onThisOrBreadthFirstChildOfKind: BrList;
		play.

	aScripterOrStep mouseMoveOverStep: [:s | 
		s label: 'Hover ' , aBlElementId asSymbol;
		onSpaceRoot;
		// BrMenuSteppedElement;
		// aBlElementId].

	aScripterOrStep clickStep: [:s | 
		s label: 'Click ' , aBlElementId asSymbol;
		onSpaceRoot;
		// BrMenuSteppedElement;
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
				GtPagerSettings usedPager createWrappedOn: aCoder asElement ];
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
