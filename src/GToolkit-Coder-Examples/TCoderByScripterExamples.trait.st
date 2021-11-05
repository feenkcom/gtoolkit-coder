Trait {
	#name : #TCoderByScripterExamples,
	#category : #'GToolkit-Coder-Examples-By scripter'
}

{ #category : #utilities }
TCoderByScripterExamples >> openAndClickOnContextMenuItemFor: aScripterOrStep id: aBlElementId [

	aScripterOrStep secondaryClick
		label: 'Open context menu';
		onChildNamed: GtSourceCoderEditorId;
		play.

	aScripterOrStep mouseMoveOver
		label: 'Hover ', aBlElementId asSymbol;
		onSpaceRoot;
		id: aBlElementId.

	aScripterOrStep wait forEmptySpaceTaskQueue.
	
	aScripterOrStep click
		label: 'Click ', aBlElementId asSymbol;
		onSpaceRoot;
		onChildNamed: aBlElementId.

	aScripterOrStep wait forEmptySpaceTaskQueue.
	aScripterOrStep syncContinue
]

{ #category : #'examples - scripter' }
TCoderByScripterExamples >> scripter [
	| scripter |
	scripter := BlDevScripter new.
	
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
		onChildNamed: GtSourceCoderEditorId;
		play.
	
	aScripterOrStep check
		label: 'Check selected text';
		value: [ :aSourceEditor | aSourceEditor editor selectedText asString ] equals: aSelectedString;
		onChildNamed: GtSourceCoderEditorId;
		play
]
