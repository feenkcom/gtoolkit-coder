Trait {
	#name : #TCoderByScripterExamples,
	#category : #'GToolkit-Coder-Examples-By scripter'
}

{ #category : #utilities }
TCoderByScripterExamples >> openAndClickOnContextMenuItemFor: aScripterOrStep id: aBlElementId [

	aScripterOrStep secondaryClick
		label: 'Open context menu';
		id: GtSourceCoderEditorId;
		play.

	aScripterOrStep mouseMoveOver
		label: 'Hover ', aBlElementId asSymbol;
		onSpaceRoot;
		id: aBlElementId;
		play.
	
	aScripterOrStep click
		label: 'Click ', aBlElementId asSymbol;
		onSpaceRoot;
		id: aBlElementId;
		play.
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
TCoderByScripterExamples >> selectTextFor: aScripterOrStep from: aStartPosition to: aToPosition andCheck: aSelectedString [
	aScripterOrStep do
		label: 'Select part of the method';
		action: [ :aSourceEditor |
			aSourceEditor selecter
				from: aStartPosition to: aToPosition;
				select ];
		id: GtSourceCoderEditorId;
		play.
	
	aScripterOrStep check
		label: 'Check selected text';
		value: [ :aSourceEditor | aSourceEditor editor selectedText asString ] equals: aSelectedString;
		id: GtSourceCoderEditorId;
		play
]
