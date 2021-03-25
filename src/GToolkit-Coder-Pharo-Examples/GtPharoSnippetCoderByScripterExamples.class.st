Class {
	#name : #GtPharoSnippetCoderByScripterExamples,
	#superclass : #Object,
	#traits : 'TCoderByScripterExamples',
	#classTraits : 'TCoderByScripterExamples classTrait',
	#category : #'GToolkit-Coder-Pharo-Examples-Coders'
}

{ #category : #'examples - context menu' }
GtPharoSnippetCoderByScripterExamples >> contextMenuInspect [
	<gtExample>
	| aScripter |

	aScripter := self scripterForBlock: [ GtPharoSnippetCoder forSource: 'Object new' ].
	self selectTextFor: aScripter from: 0 to: 6 andCheck: 'Object'.
	
	self openAndClickOnContextMenuItemFor: aScripter id: GtSourceCoderDoItAndGoActionId.
	
	aScripter check 
		label: 'Check Triggered Spawn Object Event';
		satisfies: [ :theScripter | theScripter events reversed 
			detectEventOfClass: GtPhlowObjectToSpawn
			ifFound: [ :theEvent |
				theEvent object = Object ]
			ifNone: [ AssertionFailure signal: GtPhlowObjectToSpawn name, ' event was not found' ]  ];
		onScripter.	

	^ aScripter
]
