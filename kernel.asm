
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 66 11 80       	mov    $0x801166d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 d0 31 10 80       	mov    $0x801031d0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 76 10 80       	push   $0x801076e0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 65 47 00 00       	call   801047c0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 0d                	jmp    80100086 <binit+0x46>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
    b->next = bcache.head.next;
80100086:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100089:	83 ec 08             	sub    $0x8,%esp
8010008c:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008f:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100096:	68 e7 76 10 80       	push   $0x801076e7
8010009b:	50                   	push   %eax
8010009c:	e8 ef 45 00 00       	call   80104690 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a6:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000a9:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ac:	89 d8                	mov    %ebx,%eax
801000ae:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b4:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000ba:	75 c4                	jne    80100080 <binit+0x40>
  }
}
801000bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000bf:	c9                   	leave
801000c0:	c3                   	ret
801000c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000cf:	00 

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 f7 48 00 00       	call   801049e0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 4f                	jmp    8010016a <bread+0x9a>
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 1d                	jne    8010014b <bread+0x7b>
8010012e:	eb 7e                	jmp    801001ae <bread+0xde>
80100130:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100137:	00 
80100138:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010013f:	00 
80100140:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100143:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100149:	74 63                	je     801001ae <bread+0xde>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010014b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010014e:	85 c0                	test   %eax,%eax
80100150:	75 ee                	jne    80100140 <bread+0x70>
80100152:	f6 03 04             	testb  $0x4,(%ebx)
80100155:	75 e9                	jne    80100140 <bread+0x70>
      b->dev = dev;
80100157:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010015a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010015d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100163:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010016a:	83 ec 0c             	sub    $0xc,%esp
8010016d:	68 20 b5 10 80       	push   $0x8010b520
80100172:	e8 09 48 00 00       	call   80104980 <release>
      acquiresleep(&b->lock);
80100177:	8d 43 0c             	lea    0xc(%ebx),%eax
8010017a:	89 04 24             	mov    %eax,(%esp)
8010017d:	e8 4e 45 00 00       	call   801046d0 <acquiresleep>
      return b;
80100182:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100185:	f6 03 02             	testb  $0x2,(%ebx)
80100188:	74 0e                	je     80100198 <bread+0xc8>
    iderw(b);
  }
  return b;
}
8010018a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010018d:	89 d8                	mov    %ebx,%eax
8010018f:	5b                   	pop    %ebx
80100190:	5e                   	pop    %esi
80100191:	5f                   	pop    %edi
80100192:	5d                   	pop    %ebp
80100193:	c3                   	ret
80100194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100198:	83 ec 0c             	sub    $0xc,%esp
8010019b:	53                   	push   %ebx
8010019c:	e8 1f 22 00 00       	call   801023c0 <iderw>
801001a1:	83 c4 10             	add    $0x10,%esp
}
801001a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801001a7:	89 d8                	mov    %ebx,%eax
801001a9:	5b                   	pop    %ebx
801001aa:	5e                   	pop    %esi
801001ab:	5f                   	pop    %edi
801001ac:	5d                   	pop    %ebp
801001ad:	c3                   	ret
  panic("bget: no buffers");
801001ae:	83 ec 0c             	sub    $0xc,%esp
801001b1:	68 ee 76 10 80       	push   $0x801076ee
801001b6:	e8 e5 01 00 00       	call   801003a0 <panic>
801001bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801001c0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001c0:	55                   	push   %ebp
801001c1:	89 e5                	mov    %esp,%ebp
801001c3:	53                   	push   %ebx
801001c4:	83 ec 10             	sub    $0x10,%esp
801001c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ca:	8d 43 0c             	lea    0xc(%ebx),%eax
801001cd:	50                   	push   %eax
801001ce:	e8 9d 45 00 00       	call   80104770 <holdingsleep>
801001d3:	83 c4 10             	add    $0x10,%esp
801001d6:	85 c0                	test   %eax,%eax
801001d8:	74 0f                	je     801001e9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001da:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001dd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001e3:	c9                   	leave
  iderw(b);
801001e4:	e9 d7 21 00 00       	jmp    801023c0 <iderw>
    panic("bwrite");
801001e9:	83 ec 0c             	sub    $0xc,%esp
801001ec:	68 ff 76 10 80       	push   $0x801076ff
801001f1:	e8 aa 01 00 00       	call   801003a0 <panic>
801001f6:	66 90                	xchg   %ax,%ax
801001f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ff:	00 

80100200 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100200:	55                   	push   %ebp
80100201:	89 e5                	mov    %esp,%ebp
80100203:	56                   	push   %esi
80100204:	53                   	push   %ebx
80100205:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
80100208:	8d 73 0c             	lea    0xc(%ebx),%esi
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 5c 45 00 00       	call   80104770 <holdingsleep>
80100214:	83 c4 10             	add    $0x10,%esp
80100217:	85 c0                	test   %eax,%eax
80100219:	74 63                	je     8010027e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010021b:	83 ec 0c             	sub    $0xc,%esp
8010021e:	56                   	push   %esi
8010021f:	e8 0c 45 00 00       	call   80104730 <releasesleep>

  acquire(&bcache.lock);
80100224:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010022b:	e8 b0 47 00 00       	call   801049e0 <acquire>
  b->refcnt--;
80100230:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100233:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100236:	83 e8 01             	sub    $0x1,%eax
80100239:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 2c                	jne    8010026c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	8b 43 50             	mov    0x50(%ebx),%eax
80100246:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100249:	8b 53 54             	mov    0x54(%ebx),%edx
8010024c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010024f:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100254:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010025b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010025e:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100263:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100266:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010026c:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100273:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100276:	5b                   	pop    %ebx
80100277:	5e                   	pop    %esi
80100278:	5d                   	pop    %ebp
  release(&bcache.lock);
80100279:	e9 02 47 00 00       	jmp    80104980 <release>
    panic("brelse");
8010027e:	83 ec 0c             	sub    $0xc,%esp
80100281:	68 06 77 10 80       	push   $0x80107706
80100286:	e8 15 01 00 00       	call   801003a0 <panic>
8010028b:	66 90                	xchg   %ax,%ax
8010028d:	66 90                	xchg   %ax,%ax
8010028f:	66 90                	xchg   %ax,%ax
80100291:	66 90                	xchg   %ax,%ax
80100293:	66 90                	xchg   %ax,%ax
80100295:	66 90                	xchg   %ax,%ax
80100297:	66 90                	xchg   %ax,%ax
80100299:	66 90                	xchg   %ax,%ax
8010029b:	66 90                	xchg   %ax,%ax
8010029d:	66 90                	xchg   %ax,%ax
8010029f:	90                   	nop

801002a0 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
801002a0:	55                   	push   %ebp
801002a1:	89 e5                	mov    %esp,%ebp
801002a3:	57                   	push   %edi
801002a4:	56                   	push   %esi
801002a5:	53                   	push   %ebx
801002a6:	83 ec 18             	sub    $0x18,%esp
801002a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
801002af:	ff 75 08             	push   0x8(%ebp)
  target = n;
801002b2:	89 df                	mov    %ebx,%edi
  iunlock(ip);
801002b4:	e8 97 16 00 00       	call   80101950 <iunlock>
  acquire(&cons.lock);
801002b9:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002c0:	e8 1b 47 00 00       	call   801049e0 <acquire>
  while(n > 0){
801002c5:	83 c4 10             	add    $0x10,%esp
801002c8:	85 db                	test   %ebx,%ebx
801002ca:	0f 8e 94 00 00 00    	jle    80100364 <consoleread+0xc4>
    while(input.r == input.w){
801002d0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d5:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
801002db:	74 25                	je     80100302 <consoleread+0x62>
801002dd:	eb 59                	jmp    80100338 <consoleread+0x98>
801002df:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002e0:	83 ec 08             	sub    $0x8,%esp
801002e3:	68 20 ff 10 80       	push   $0x8010ff20
801002e8:	68 00 ff 10 80       	push   $0x8010ff00
801002ed:	e8 0e 41 00 00       	call   80104400 <sleep>
    while(input.r == input.w){
801002f2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002f7:	83 c4 10             	add    $0x10,%esp
801002fa:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100300:	75 36                	jne    80100338 <consoleread+0x98>
      if(myproc()->killed){
80100302:	e8 99 38 00 00       	call   80103ba0 <myproc>
80100307:	8b 48 24             	mov    0x24(%eax),%ecx
8010030a:	85 c9                	test   %ecx,%ecx
8010030c:	74 d2                	je     801002e0 <consoleread+0x40>
        release(&cons.lock);
8010030e:	83 ec 0c             	sub    $0xc,%esp
80100311:	68 20 ff 10 80       	push   $0x8010ff20
80100316:	e8 65 46 00 00       	call   80104980 <release>
        ilock(ip);
8010031b:	5a                   	pop    %edx
8010031c:	ff 75 08             	push   0x8(%ebp)
8010031f:	e8 4c 15 00 00       	call   80101870 <ilock>
        return -1;
80100324:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100327:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010032a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010032f:	5b                   	pop    %ebx
80100330:	5e                   	pop    %esi
80100331:	5f                   	pop    %edi
80100332:	5d                   	pop    %ebp
80100333:	c3                   	ret
80100334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100338:	8d 50 01             	lea    0x1(%eax),%edx
8010033b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100341:	89 c2                	mov    %eax,%edx
80100343:	83 e2 7f             	and    $0x7f,%edx
80100346:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010034d:	80 f9 04             	cmp    $0x4,%cl
80100350:	74 37                	je     80100389 <consoleread+0xe9>
    *dst++ = c;
80100352:	83 c6 01             	add    $0x1,%esi
    --n;
80100355:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100358:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010035b:	83 f9 0a             	cmp    $0xa,%ecx
8010035e:	0f 85 64 ff ff ff    	jne    801002c8 <consoleread+0x28>
  release(&cons.lock);
80100364:	83 ec 0c             	sub    $0xc,%esp
80100367:	68 20 ff 10 80       	push   $0x8010ff20
8010036c:	e8 0f 46 00 00       	call   80104980 <release>
  ilock(ip);
80100371:	58                   	pop    %eax
80100372:	ff 75 08             	push   0x8(%ebp)
80100375:	e8 f6 14 00 00       	call   80101870 <ilock>
  return target - n;
8010037a:	89 f8                	mov    %edi,%eax
8010037c:	83 c4 10             	add    $0x10,%esp
}
8010037f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100382:	29 d8                	sub    %ebx,%eax
}
80100384:	5b                   	pop    %ebx
80100385:	5e                   	pop    %esi
80100386:	5f                   	pop    %edi
80100387:	5d                   	pop    %ebp
80100388:	c3                   	ret
      if(n < target){
80100389:	39 fb                	cmp    %edi,%ebx
8010038b:	73 d7                	jae    80100364 <consoleread+0xc4>
        input.r--;
8010038d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100392:	eb d0                	jmp    80100364 <consoleread+0xc4>
80100394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100398:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010039f:	00 

801003a0 <panic>:
{
801003a0:	55                   	push   %ebp
801003a1:	89 e5                	mov    %esp,%ebp
801003a3:	53                   	push   %ebx
801003a4:	83 ec 34             	sub    $0x34,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
801003a7:	fa                   	cli
  cons.locking = 0;
801003a8:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
801003af:	00 00 00 
  getcallerpcs(&s, pcs);
801003b2:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cprintf("lapicid %d: panic: ", lapicid());
801003b5:	e8 46 26 00 00       	call   80102a00 <lapicid>
801003ba:	83 ec 08             	sub    $0x8,%esp
801003bd:	50                   	push   %eax
801003be:	68 0d 77 10 80       	push   $0x8010770d
801003c3:	e8 08 03 00 00       	call   801006d0 <cprintf>
  cprintf(s);
801003c8:	58                   	pop    %eax
801003c9:	ff 75 08             	push   0x8(%ebp)
801003cc:	e8 ff 02 00 00       	call   801006d0 <cprintf>
  cprintf("\n");
801003d1:	c7 04 24 8f 7b 10 80 	movl   $0x80107b8f,(%esp)
801003d8:	e8 f3 02 00 00       	call   801006d0 <cprintf>
  getcallerpcs(&s, pcs);
801003dd:	8d 45 08             	lea    0x8(%ebp),%eax
801003e0:	5a                   	pop    %edx
801003e1:	59                   	pop    %ecx
801003e2:	53                   	push   %ebx
801003e3:	50                   	push   %eax
801003e4:	e8 f7 43 00 00       	call   801047e0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e9:	83 c4 10             	add    $0x10,%esp
801003ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003f0:	83 ec 08             	sub    $0x8,%esp
801003f3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003f5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003f8:	68 21 77 10 80       	push   $0x80107721
801003fd:	e8 ce 02 00 00       	call   801006d0 <cprintf>
  for(i=0; i<10; i++)
80100402:	8d 45 f8             	lea    -0x8(%ebp),%eax
80100405:	83 c4 10             	add    $0x10,%esp
80100408:	39 c3                	cmp    %eax,%ebx
8010040a:	75 e4                	jne    801003f0 <panic+0x50>
  panicked = 1; // freeze other CPU
8010040c:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
80100413:	00 00 00 
  for(;;)
80100416:	eb fe                	jmp    80100416 <panic+0x76>
80100418:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010041f:	00 

80100420 <consputc.part.0>:
consputc(int c)
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
80100429:	3d 00 01 00 00       	cmp    $0x100,%eax
8010042e:	0f 84 cc 00 00 00    	je     80100500 <consputc.part.0+0xe0>
    uartputc(c);
80100434:	83 ec 0c             	sub    $0xc,%esp
80100437:	89 c3                	mov    %eax,%ebx
80100439:	50                   	push   %eax
8010043a:	e8 01 5e 00 00       	call   80106240 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100444:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100449:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044a:	ba d5 03 00 00       	mov    $0x3d5,%edx
8010044f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100450:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100453:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100458:	b8 0f 00 00 00       	mov    $0xf,%eax
8010045d:	c1 e1 08             	shl    $0x8,%ecx
80100460:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100461:	ba d5 03 00 00       	mov    $0x3d5,%edx
80100466:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100467:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
8010046a:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010046d:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010046f:	83 fb 0a             	cmp    $0xa,%ebx
80100472:	75 74                	jne    801004e8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100474:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100479:	f7 e2                	mul    %edx
8010047b:	c1 ea 06             	shr    $0x6,%edx
8010047e:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100481:	c1 e0 04             	shl    $0x4,%eax
80100484:	8d 78 50             	lea    0x50(%eax),%edi
  if(pos < 0 || pos > 25*80)
80100487:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010048d:	0f 8f 23 01 00 00    	jg     801005b6 <consputc.part.0+0x196>
  if((pos/80) >= 24){  // Scroll up.
80100493:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100499:	0f 8f c1 00 00 00    	jg     80100560 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010049f:	89 f8                	mov    %edi,%eax
  outb(CRTPORT+1, pos);
801004a1:	89 fb                	mov    %edi,%ebx
  crt[pos] = ' ' | 0x0700;
801004a3:	8d bc 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%edi
  outb(CRTPORT+1, pos>>8);
801004aa:	0f b6 f4             	movzbl %ah,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	ba d4 03 00 00       	mov    $0x3d4,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bd:	89 f0                	mov    %esi,%eax
801004bf:	ee                   	out    %al,(%dx)
801004c0:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c5:	ba d4 03 00 00       	mov    $0x3d4,%edx
801004ca:	ee                   	out    %al,(%dx)
801004cb:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004d0:	89 d8                	mov    %ebx,%eax
801004d2:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d3:	b8 20 07 00 00       	mov    $0x720,%eax
801004d8:	66 89 07             	mov    %ax,(%edi)
}
801004db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004de:	5b                   	pop    %ebx
801004df:	5e                   	pop    %esi
801004e0:	5f                   	pop    %edi
801004e1:	5d                   	pop    %ebp
801004e2:	c3                   	ret
801004e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004e8:	0f b6 db             	movzbl %bl,%ebx
801004eb:	8d 78 01             	lea    0x1(%eax),%edi
801004ee:	80 cf 07             	or     $0x7,%bh
801004f1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004f8:	80 
801004f9:	eb 8c                	jmp    80100487 <consputc.part.0+0x67>
801004fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 36 5d 00 00       	call   80106240 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 2a 5d 00 00       	call   80106240 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 1e 5d 00 00       	call   80106240 <uartputc>
80100522:	b8 0e 00 00 00       	mov    $0xe,%eax
80100527:	ba d4 03 00 00       	mov    $0x3d4,%edx
8010052c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010052d:	ba d5 03 00 00       	mov    $0x3d5,%edx
80100532:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100533:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100536:	ba d4 03 00 00       	mov    $0x3d4,%edx
8010053b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100540:	c1 e3 08             	shl    $0x8,%ebx
80100543:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100544:	ba d5 03 00 00       	mov    $0x3d5,%edx
80100549:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010054a:	0f b6 c8             	movzbl %al,%ecx
    if(pos > 0) --pos;
8010054d:	83 c4 10             	add    $0x10,%esp
80100550:	09 d9                	or     %ebx,%ecx
80100552:	74 54                	je     801005a8 <consputc.part.0+0x188>
80100554:	8d 79 ff             	lea    -0x1(%ecx),%edi
80100557:	e9 2b ff ff ff       	jmp    80100487 <consputc.part.0+0x67>
8010055c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100560:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100563:	8d 5f b0             	lea    -0x50(%edi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	8d bc 3f 60 7f 0b 80 	lea    -0x7ff480a0(%edi,%edi,1),%edi
  outb(CRTPORT+1, pos);
8010056d:	be 07 00 00 00       	mov    $0x7,%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100572:	68 60 0e 00 00       	push   $0xe60
80100577:	68 a0 80 0b 80       	push   $0x800b80a0
8010057c:	68 00 80 0b 80       	push   $0x800b8000
80100581:	e8 0a 46 00 00       	call   80104b90 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100586:	b8 80 07 00 00       	mov    $0x780,%eax
8010058b:	83 c4 0c             	add    $0xc,%esp
8010058e:	29 d8                	sub    %ebx,%eax
80100590:	01 c0                	add    %eax,%eax
80100592:	50                   	push   %eax
80100593:	6a 00                	push   $0x0
80100595:	57                   	push   %edi
80100596:	e8 65 45 00 00       	call   80104b00 <memset>
  outb(CRTPORT+1, pos);
8010059b:	83 c4 10             	add    $0x10,%esp
8010059e:	e9 0a ff ff ff       	jmp    801004ad <consputc.part.0+0x8d>
801005a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801005a8:	bf 00 80 0b 80       	mov    $0x800b8000,%edi
801005ad:	31 db                	xor    %ebx,%ebx
801005af:	31 f6                	xor    %esi,%esi
801005b1:	e9 f7 fe ff ff       	jmp    801004ad <consputc.part.0+0x8d>
    panic("pos under/overflow");
801005b6:	83 ec 0c             	sub    $0xc,%esp
801005b9:	68 25 77 10 80       	push   $0x80107725
801005be:	e8 dd fd ff ff       	call   801003a0 <panic>
801005c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801005c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801005cf:	00 

801005d0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005d0:	55                   	push   %ebp
801005d1:	89 e5                	mov    %esp,%ebp
801005d3:	57                   	push   %edi
801005d4:	56                   	push   %esi
801005d5:	53                   	push   %ebx
801005d6:	83 ec 18             	sub    $0x18,%esp
801005d9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005dc:	ff 75 08             	push   0x8(%ebp)
801005df:	e8 6c 13 00 00       	call   80101950 <iunlock>
  acquire(&cons.lock);
801005e4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005eb:	e8 f0 43 00 00       	call   801049e0 <acquire>
  for(i = 0; i < n; i++)
801005f0:	83 c4 10             	add    $0x10,%esp
801005f3:	85 f6                	test   %esi,%esi
801005f5:	7e 28                	jle    8010061f <consolewrite+0x4f>
801005f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005fa:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005fd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100603:	85 d2                	test   %edx,%edx
80100605:	74 09                	je     80100610 <consolewrite+0x40>
  asm volatile("cli");
80100607:	fa                   	cli
    for(;;)
80100608:	eb fe                	jmp    80100608 <consolewrite+0x38>
8010060a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100610:	0f b6 03             	movzbl (%ebx),%eax
  for(i = 0; i < n; i++)
80100613:	83 c3 01             	add    $0x1,%ebx
80100616:	e8 05 fe ff ff       	call   80100420 <consputc.part.0>
8010061b:	39 fb                	cmp    %edi,%ebx
8010061d:	75 de                	jne    801005fd <consolewrite+0x2d>
  release(&cons.lock);
8010061f:	83 ec 0c             	sub    $0xc,%esp
80100622:	68 20 ff 10 80       	push   $0x8010ff20
80100627:	e8 54 43 00 00       	call   80104980 <release>
  ilock(ip);
8010062c:	58                   	pop    %eax
8010062d:	ff 75 08             	push   0x8(%ebp)
80100630:	e8 3b 12 00 00       	call   80101870 <ilock>

  return n;
}
80100635:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100638:	89 f0                	mov    %esi,%eax
8010063a:	5b                   	pop    %ebx
8010063b:	5e                   	pop    %esi
8010063c:	5f                   	pop    %edi
8010063d:	5d                   	pop    %ebp
8010063e:	c3                   	ret
8010063f:	90                   	nop

80100640 <printint>:
{
80100640:	55                   	push   %ebp
80100641:	89 e5                	mov    %esp,%ebp
80100643:	57                   	push   %edi
80100644:	56                   	push   %esi
80100645:	53                   	push   %ebx
80100646:	89 d3                	mov    %edx,%ebx
80100648:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010064b:	85 c0                	test   %eax,%eax
8010064d:	79 05                	jns    80100654 <printint+0x14>
8010064f:	83 e1 01             	and    $0x1,%ecx
80100652:	75 5d                	jne    801006b1 <printint+0x71>
80100654:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010065b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010065d:	31 f6                	xor    %esi,%esi
8010065f:	90                   	nop
    buf[i++] = digits[x % base];
80100660:	89 c8                	mov    %ecx,%eax
80100662:	31 d2                	xor    %edx,%edx
80100664:	89 f7                	mov    %esi,%edi
80100666:	f7 f3                	div    %ebx
80100668:	8d 76 01             	lea    0x1(%esi),%esi
  }while((x /= base) != 0);
8010066b:	39 d9                	cmp    %ebx,%ecx
    buf[i++] = digits[x % base];
8010066d:	0f b6 92 e0 7b 10 80 	movzbl -0x7fef8420(%edx),%edx
  }while((x /= base) != 0);
80100674:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
80100676:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
8010067a:	73 e4                	jae    80100660 <printint+0x20>
  if(sign)
8010067c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010067f:	85 d2                	test   %edx,%edx
80100681:	74 07                	je     8010068a <printint+0x4a>
    buf[i++] = '-';
80100683:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
80100688:	89 f7                	mov    %esi,%edi
  while(--i >= 0)
8010068a:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010068d:	01 df                	add    %ebx,%edi
  if(panicked){
8010068f:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100694:	85 c0                	test   %eax,%eax
80100696:	74 08                	je     801006a0 <printint+0x60>
80100698:	fa                   	cli
    for(;;)
80100699:	eb fe                	jmp    80100699 <printint+0x59>
8010069b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801006a0:	0f be 07             	movsbl (%edi),%eax
801006a3:	e8 78 fd ff ff       	call   80100420 <consputc.part.0>
  while(--i >= 0)
801006a8:	39 fb                	cmp    %edi,%ebx
801006aa:	74 10                	je     801006bc <printint+0x7c>
801006ac:	83 ef 01             	sub    $0x1,%edi
801006af:	eb de                	jmp    8010068f <printint+0x4f>
  if(sign && (sign = xx < 0))
801006b1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801006b8:	f7 d8                	neg    %eax
801006ba:	eb 9f                	jmp    8010065b <printint+0x1b>
}
801006bc:	83 c4 2c             	add    $0x2c,%esp
801006bf:	5b                   	pop    %ebx
801006c0:	5e                   	pop    %esi
801006c1:	5f                   	pop    %edi
801006c2:	5d                   	pop    %ebp
801006c3:	c3                   	ret
801006c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801006c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801006cf:	00 

801006d0 <cprintf>:
{
801006d0:	55                   	push   %ebp
801006d1:	89 e5                	mov    %esp,%ebp
801006d3:	57                   	push   %edi
801006d4:	56                   	push   %esi
801006d5:	53                   	push   %ebx
801006d6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006d9:	8b 15 54 ff 10 80    	mov    0x8010ff54,%edx
  if (fmt == 0)
801006df:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006e2:	85 d2                	test   %edx,%edx
801006e4:	0f 85 06 01 00 00    	jne    801007f0 <cprintf+0x120>
  if (fmt == 0)
801006ea:	85 f6                	test   %esi,%esi
801006ec:	0f 84 c2 01 00 00    	je     801008b4 <cprintf+0x1e4>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f2:	0f b6 06             	movzbl (%esi),%eax
801006f5:	85 c0                	test   %eax,%eax
801006f7:	74 57                	je     80100750 <cprintf+0x80>
801006f9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  argp = (uint*)(void*)(&fmt + 1);
801006fc:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ff:	31 db                	xor    %ebx,%ebx
    if(c != '%'){
80100701:	83 f8 25             	cmp    $0x25,%eax
80100704:	75 5a                	jne    80100760 <cprintf+0x90>
    c = fmt[++i] & 0xff;
80100706:	83 c3 01             	add    $0x1,%ebx
80100709:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
8010070d:	85 d2                	test   %edx,%edx
8010070f:	74 34                	je     80100745 <cprintf+0x75>
    switch(c){
80100711:	83 fa 70             	cmp    $0x70,%edx
80100714:	0f 84 b6 00 00 00    	je     801007d0 <cprintf+0x100>
8010071a:	7f 74                	jg     80100790 <cprintf+0xc0>
8010071c:	83 fa 25             	cmp    $0x25,%edx
8010071f:	74 4f                	je     80100770 <cprintf+0xa0>
80100721:	83 fa 64             	cmp    $0x64,%edx
80100724:	75 78                	jne    8010079e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100726:	8b 07                	mov    (%edi),%eax
80100728:	b9 01 00 00 00       	mov    $0x1,%ecx
8010072d:	ba 0a 00 00 00       	mov    $0xa,%edx
80100732:	83 c7 04             	add    $0x4,%edi
80100735:	e8 06 ff ff ff       	call   80100640 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010073a:	83 c3 01             	add    $0x1,%ebx
8010073d:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100741:	85 c0                	test   %eax,%eax
80100743:	75 bc                	jne    80100701 <cprintf+0x31>
80100745:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  if(locking)
80100748:	85 d2                	test   %edx,%edx
8010074a:	0f 85 c9 00 00 00    	jne    80100819 <cprintf+0x149>
}
80100750:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100753:	5b                   	pop    %ebx
80100754:	5e                   	pop    %esi
80100755:	5f                   	pop    %edi
80100756:	5d                   	pop    %ebp
80100757:	c3                   	ret
80100758:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010075f:	00 
  if(panicked){
80100760:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100766:	85 c9                	test   %ecx,%ecx
80100768:	74 18                	je     80100782 <cprintf+0xb2>
8010076a:	fa                   	cli
    for(;;)
8010076b:	eb fe                	jmp    8010076b <cprintf+0x9b>
8010076d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100770:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100775:	85 c0                	test   %eax,%eax
80100777:	0f 85 1b 01 00 00    	jne    80100898 <cprintf+0x1c8>
8010077d:	b8 25 00 00 00       	mov    $0x25,%eax
80100782:	e8 99 fc ff ff       	call   80100420 <consputc.part.0>
      break;
80100787:	eb b1                	jmp    8010073a <cprintf+0x6a>
80100789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100790:	83 fa 73             	cmp    $0x73,%edx
80100793:	0f 84 95 00 00 00    	je     8010082e <cprintf+0x15e>
80100799:	83 fa 78             	cmp    $0x78,%edx
8010079c:	74 32                	je     801007d0 <cprintf+0x100>
  if(panicked){
8010079e:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007a4:	85 c9                	test   %ecx,%ecx
801007a6:	0f 85 e5 00 00 00    	jne    80100891 <cprintf+0x1c1>
801007ac:	b8 25 00 00 00       	mov    $0x25,%eax
801007b1:	89 55 e0             	mov    %edx,-0x20(%ebp)
801007b4:	e8 67 fc ff ff       	call   80100420 <consputc.part.0>
801007b9:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801007be:	85 c0                	test   %eax,%eax
801007c0:	0f 84 da 00 00 00    	je     801008a0 <cprintf+0x1d0>
801007c6:	fa                   	cli
    for(;;)
801007c7:	eb fe                	jmp    801007c7 <cprintf+0xf7>
801007c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007d0:	8b 07                	mov    (%edi),%eax
801007d2:	31 c9                	xor    %ecx,%ecx
801007d4:	ba 10 00 00 00       	mov    $0x10,%edx
801007d9:	83 c7 04             	add    $0x4,%edi
801007dc:	e8 5f fe ff ff       	call   80100640 <printint>
      break;
801007e1:	e9 54 ff ff ff       	jmp    8010073a <cprintf+0x6a>
801007e6:	66 90                	xchg   %ax,%ax
801007e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801007ef:	00 
    acquire(&cons.lock);
801007f0:	83 ec 0c             	sub    $0xc,%esp
801007f3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801007f6:	68 20 ff 10 80       	push   $0x8010ff20
801007fb:	e8 e0 41 00 00       	call   801049e0 <acquire>
  if (fmt == 0)
80100800:	83 c4 10             	add    $0x10,%esp
80100803:	85 f6                	test   %esi,%esi
80100805:	0f 84 a9 00 00 00    	je     801008b4 <cprintf+0x1e4>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010080b:	0f b6 06             	movzbl (%esi),%eax
8010080e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100811:	85 c0                	test   %eax,%eax
80100813:	0f 85 e0 fe ff ff    	jne    801006f9 <cprintf+0x29>
    release(&cons.lock);
80100819:	83 ec 0c             	sub    $0xc,%esp
8010081c:	68 20 ff 10 80       	push   $0x8010ff20
80100821:	e8 5a 41 00 00       	call   80104980 <release>
80100826:	83 c4 10             	add    $0x10,%esp
80100829:	e9 22 ff ff ff       	jmp    80100750 <cprintf+0x80>
      if((s = (char*)*argp++) == 0)
8010082e:	8d 57 04             	lea    0x4(%edi),%edx
80100831:	8b 3f                	mov    (%edi),%edi
80100833:	85 ff                	test   %edi,%edi
80100835:	74 21                	je     80100858 <cprintf+0x188>
      for(; *s; s++)
80100837:	0f be 07             	movsbl (%edi),%eax
8010083a:	84 c0                	test   %al,%al
8010083c:	74 6f                	je     801008ad <cprintf+0x1dd>
8010083e:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80100841:	89 fb                	mov    %edi,%ebx
80100843:	89 f7                	mov    %esi,%edi
80100845:	89 d6                	mov    %edx,%esi
  if(panicked){
80100847:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
8010084d:	85 d2                	test   %edx,%edx
8010084f:	74 22                	je     80100873 <cprintf+0x1a3>
80100851:	fa                   	cli
    for(;;)
80100852:	eb fe                	jmp    80100852 <cprintf+0x182>
80100854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
80100858:	89 f7                	mov    %esi,%edi
8010085a:	89 d6                	mov    %edx,%esi
  if(panicked){
8010085c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        s = "(null)";
80100862:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80100865:	b8 28 00 00 00       	mov    $0x28,%eax
8010086a:	bb 38 77 10 80       	mov    $0x80107738,%ebx
  if(panicked){
8010086f:	85 d2                	test   %edx,%edx
80100871:	75 de                	jne    80100851 <cprintf+0x181>
80100873:	e8 a8 fb ff ff       	call   80100420 <consputc.part.0>
      for(; *s; s++)
80100878:	0f be 43 01          	movsbl 0x1(%ebx),%eax
8010087c:	83 c3 01             	add    $0x1,%ebx
8010087f:	84 c0                	test   %al,%al
80100881:	75 c4                	jne    80100847 <cprintf+0x177>
      if((s = (char*)*argp++) == 0)
80100883:	89 f2                	mov    %esi,%edx
80100885:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80100888:	89 fe                	mov    %edi,%esi
8010088a:	89 d7                	mov    %edx,%edi
8010088c:	e9 a9 fe ff ff       	jmp    8010073a <cprintf+0x6a>
80100891:	fa                   	cli
    for(;;)
80100892:	eb fe                	jmp    80100892 <cprintf+0x1c2>
80100894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100898:	fa                   	cli
80100899:	eb fe                	jmp    80100899 <cprintf+0x1c9>
8010089b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801008a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801008a3:	e8 78 fb ff ff       	call   80100420 <consputc.part.0>
      break;
801008a8:	e9 8d fe ff ff       	jmp    8010073a <cprintf+0x6a>
      if((s = (char*)*argp++) == 0)
801008ad:	89 d7                	mov    %edx,%edi
801008af:	e9 86 fe ff ff       	jmp    8010073a <cprintf+0x6a>
    panic("null fmt");
801008b4:	83 ec 0c             	sub    $0xc,%esp
801008b7:	68 3f 77 10 80       	push   $0x8010773f
801008bc:	e8 df fa ff ff       	call   801003a0 <panic>
801008c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801008c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801008cf:	00 

801008d0 <consoleintr>:
{
801008d0:	55                   	push   %ebp
801008d1:	89 e5                	mov    %esp,%ebp
801008d3:	57                   	push   %edi
801008d4:	56                   	push   %esi
  int c, doprocdump = 0;
801008d5:	31 f6                	xor    %esi,%esi
{
801008d7:	53                   	push   %ebx
801008d8:	83 ec 28             	sub    $0x28,%esp
801008db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801008de:	68 20 ff 10 80       	push   $0x8010ff20
801008e3:	e8 f8 40 00 00       	call   801049e0 <acquire>
  while((c = getc()) >= 0){
801008e8:	83 c4 10             	add    $0x10,%esp
801008eb:	ff d3                	call   *%ebx
801008ed:	85 c0                	test   %eax,%eax
801008ef:	78 20                	js     80100911 <consoleintr+0x41>
    switch(c){
801008f1:	83 f8 15             	cmp    $0x15,%eax
801008f4:	74 42                	je     80100938 <consoleintr+0x68>
801008f6:	7f 78                	jg     80100970 <consoleintr+0xa0>
801008f8:	83 f8 08             	cmp    $0x8,%eax
801008fb:	74 78                	je     80100975 <consoleintr+0xa5>
801008fd:	83 f8 10             	cmp    $0x10,%eax
80100900:	0f 85 37 01 00 00    	jne    80100a3d <consoleintr+0x16d>
80100906:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
8010090b:	ff d3                	call   *%ebx
8010090d:	85 c0                	test   %eax,%eax
8010090f:	79 e0                	jns    801008f1 <consoleintr+0x21>
  release(&cons.lock);
80100911:	83 ec 0c             	sub    $0xc,%esp
80100914:	68 20 ff 10 80       	push   $0x8010ff20
80100919:	e8 62 40 00 00       	call   80104980 <release>
  if(doprocdump) {
8010091e:	83 c4 10             	add    $0x10,%esp
80100921:	85 f6                	test   %esi,%esi
80100923:	0f 85 7a 01 00 00    	jne    80100aa3 <consoleintr+0x1d3>
}
80100929:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010092c:	5b                   	pop    %ebx
8010092d:	5e                   	pop    %esi
8010092e:	5f                   	pop    %edi
8010092f:	5d                   	pop    %ebp
80100930:	c3                   	ret
80100931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100938:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
8010093d:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
80100943:	74 a6                	je     801008eb <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100945:	83 e8 01             	sub    $0x1,%eax
80100948:	89 c2                	mov    %eax,%edx
8010094a:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
8010094d:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100954:	74 95                	je     801008eb <consoleintr+0x1b>
  if(panicked){
80100956:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010095c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100961:	85 d2                	test   %edx,%edx
80100963:	74 3b                	je     801009a0 <consoleintr+0xd0>
80100965:	fa                   	cli
    for(;;)
80100966:	eb fe                	jmp    80100966 <consoleintr+0x96>
80100968:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010096f:	00 
    switch(c){
80100970:	83 f8 7f             	cmp    $0x7f,%eax
80100973:	75 4b                	jne    801009c0 <consoleintr+0xf0>
      if(input.e != input.w){
80100975:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
8010097a:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100980:	0f 84 65 ff ff ff    	je     801008eb <consoleintr+0x1b>
        input.e--;
80100986:	83 e8 01             	sub    $0x1,%eax
80100989:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
8010098e:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100993:	85 c0                	test   %eax,%eax
80100995:	0f 84 f9 00 00 00    	je     80100a94 <consoleintr+0x1c4>
8010099b:	fa                   	cli
    for(;;)
8010099c:	eb fe                	jmp    8010099c <consoleintr+0xcc>
8010099e:	66 90                	xchg   %ax,%ax
801009a0:	b8 00 01 00 00       	mov    $0x100,%eax
801009a5:	e8 76 fa ff ff       	call   80100420 <consputc.part.0>
      while(input.e != input.w &&
801009aa:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009af:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009b5:	75 8e                	jne    80100945 <consoleintr+0x75>
801009b7:	e9 2f ff ff ff       	jmp    801008eb <consoleintr+0x1b>
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009c0:	8b 15 08 ff 10 80    	mov    0x8010ff08,%edx
801009c6:	89 d1                	mov    %edx,%ecx
801009c8:	2b 0d 00 ff 10 80    	sub    0x8010ff00,%ecx
801009ce:	83 f9 7f             	cmp    $0x7f,%ecx
801009d1:	0f 87 14 ff ff ff    	ja     801008eb <consoleintr+0x1b>
  if(panicked){
801009d7:	8b 3d 58 ff 10 80    	mov    0x8010ff58,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801009dd:	8d 4a 01             	lea    0x1(%edx),%ecx
801009e0:	83 e2 7f             	and    $0x7f,%edx
801009e3:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
801009e9:	88 82 80 fe 10 80    	mov    %al,-0x7fef0180(%edx)
  if(panicked){
801009ef:	85 ff                	test   %edi,%edi
801009f1:	0f 85 b8 00 00 00    	jne    80100aaf <consoleintr+0x1df>
801009f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801009fa:	e8 21 fa ff ff       	call   80100420 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100a02:	8b 15 08 ff 10 80    	mov    0x8010ff08,%edx
80100a08:	83 f8 0a             	cmp    $0xa,%eax
80100a0b:	74 15                	je     80100a22 <consoleintr+0x152>
80100a0d:	83 f8 04             	cmp    $0x4,%eax
80100a10:	74 10                	je     80100a22 <consoleintr+0x152>
80100a12:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80100a17:	83 e8 80             	sub    $0xffffff80,%eax
80100a1a:	39 d0                	cmp    %edx,%eax
80100a1c:	0f 85 c9 fe ff ff    	jne    801008eb <consoleintr+0x1b>
          wakeup(&input.r);
80100a22:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a25:	89 15 04 ff 10 80    	mov    %edx,0x8010ff04
          wakeup(&input.r);
80100a2b:	68 00 ff 10 80       	push   $0x8010ff00
80100a30:	e8 ab 3a 00 00       	call   801044e0 <wakeup>
80100a35:	83 c4 10             	add    $0x10,%esp
80100a38:	e9 ae fe ff ff       	jmp    801008eb <consoleintr+0x1b>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100a3d:	85 c0                	test   %eax,%eax
80100a3f:	0f 84 a6 fe ff ff    	je     801008eb <consoleintr+0x1b>
80100a45:	8b 15 08 ff 10 80    	mov    0x8010ff08,%edx
80100a4b:	89 d1                	mov    %edx,%ecx
80100a4d:	2b 0d 00 ff 10 80    	sub    0x8010ff00,%ecx
80100a53:	83 f9 7f             	cmp    $0x7f,%ecx
80100a56:	0f 87 8f fe ff ff    	ja     801008eb <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a5c:	8d 4a 01             	lea    0x1(%edx),%ecx
  if(panicked){
80100a5f:	8b 3d 58 ff 10 80    	mov    0x8010ff58,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100a65:	83 e2 7f             	and    $0x7f,%edx
        c = (c == '\r') ? '\n' : c;
80100a68:	83 f8 0d             	cmp    $0xd,%eax
80100a6b:	0f 85 72 ff ff ff    	jne    801009e3 <consoleintr+0x113>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a71:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
80100a77:	c6 82 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%edx)
  if(panicked){
80100a7e:	85 ff                	test   %edi,%edi
80100a80:	75 2d                	jne    80100aaf <consoleintr+0x1df>
80100a82:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a87:	e8 94 f9 ff ff       	call   80100420 <consputc.part.0>
          input.w = input.e;
80100a8c:	8b 15 08 ff 10 80    	mov    0x8010ff08,%edx
80100a92:	eb 8e                	jmp    80100a22 <consoleintr+0x152>
80100a94:	b8 00 01 00 00       	mov    $0x100,%eax
80100a99:	e8 82 f9 ff ff       	call   80100420 <consputc.part.0>
80100a9e:	e9 48 fe ff ff       	jmp    801008eb <consoleintr+0x1b>
}
80100aa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100aa6:	5b                   	pop    %ebx
80100aa7:	5e                   	pop    %esi
80100aa8:	5f                   	pop    %edi
80100aa9:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100aaa:	e9 11 3b 00 00       	jmp    801045c0 <procdump>
80100aaf:	fa                   	cli
    for(;;)
80100ab0:	eb fe                	jmp    80100ab0 <consoleintr+0x1e0>
80100ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100ab8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100abf:	00 

80100ac0 <consoleinit>:

void
consoleinit(void)
{
80100ac0:	55                   	push   %ebp
80100ac1:	89 e5                	mov    %esp,%ebp
80100ac3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100ac6:	68 48 77 10 80       	push   $0x80107748
80100acb:	68 20 ff 10 80       	push   $0x8010ff20
80100ad0:	e8 eb 3c 00 00       	call   801047c0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100ad5:	58                   	pop    %eax
80100ad6:	5a                   	pop    %edx
80100ad7:	6a 00                	push   $0x0
80100ad9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100adb:	c7 05 0c 09 11 80 d0 	movl   $0x801005d0,0x8011090c
80100ae2:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100ae5:	c7 05 08 09 11 80 a0 	movl   $0x801002a0,0x80110908
80100aec:	02 10 80 
  cons.locking = 1;
80100aef:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100af6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100af9:	e8 82 1a 00 00       	call   80102580 <ioapicenable>
}
80100afe:	83 c4 10             	add    $0x10,%esp
80100b01:	c9                   	leave
80100b02:	c3                   	ret
80100b03:	66 90                	xchg   %ax,%ax
80100b05:	66 90                	xchg   %ax,%ax
80100b07:	66 90                	xchg   %ax,%ax
80100b09:	66 90                	xchg   %ax,%ax
80100b0b:	66 90                	xchg   %ax,%ax
80100b0d:	66 90                	xchg   %ax,%ax
80100b0f:	90                   	nop

80100b10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b10:	55                   	push   %ebp
80100b11:	89 e5                	mov    %esp,%ebp
80100b13:	57                   	push   %edi
80100b14:	56                   	push   %esi
80100b15:	53                   	push   %ebx
80100b16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b1c:	e8 7f 30 00 00       	call   80103ba0 <myproc>
80100b21:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100b27:	e8 b4 23 00 00       	call   80102ee0 <begin_op>

  if((ip = namei(path)) == 0){
80100b2c:	83 ec 0c             	sub    $0xc,%esp
80100b2f:	ff 75 08             	push   0x8(%ebp)
80100b32:	e8 59 16 00 00       	call   80102190 <namei>
80100b37:	83 c4 10             	add    $0x10,%esp
80100b3a:	85 c0                	test   %eax,%eax
80100b3c:	0f 84 30 03 00 00    	je     80100e72 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b42:	83 ec 0c             	sub    $0xc,%esp
80100b45:	89 c7                	mov    %eax,%edi
80100b47:	50                   	push   %eax
80100b48:	e8 23 0d 00 00       	call   80101870 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b53:	6a 34                	push   $0x34
80100b55:	6a 00                	push   $0x0
80100b57:	50                   	push   %eax
80100b58:	57                   	push   %edi
80100b59:	e8 32 10 00 00       	call   80101b90 <readi>
80100b5e:	83 c4 20             	add    $0x20,%esp
80100b61:	83 f8 34             	cmp    $0x34,%eax
80100b64:	0f 85 01 01 00 00    	jne    80100c6b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b6a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b71:	45 4c 46 
80100b74:	0f 85 f1 00 00 00    	jne    80100c6b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b7a:	e8 21 68 00 00       	call   801073a0 <setupkvm>
80100b7f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b85:	85 c0                	test   %eax,%eax
80100b87:	0f 84 de 00 00 00    	je     80100c6b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b8d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b94:	00 
80100b95:	0f 84 a7 02 00 00    	je     80100e42 <exec+0x332>
  sz = 0;
80100b9b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100ba2:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ba5:	8b 9d 40 ff ff ff    	mov    -0xc0(%ebp),%ebx
80100bab:	31 f6                	xor    %esi,%esi
80100bad:	e9 8c 00 00 00       	jmp    80100c3e <exec+0x12e>
80100bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100bb8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100bbf:	75 6c                	jne    80100c2d <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100bc1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100bc7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100bcd:	0f 82 87 00 00 00    	jb     80100c5a <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100bd3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100bd9:	72 7f                	jb     80100c5a <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bdb:	83 ec 04             	sub    $0x4,%esp
80100bde:	50                   	push   %eax
80100bdf:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100be5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100beb:	e8 e0 65 00 00       	call   801071d0 <allocuvm>
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bf9:	85 c0                	test   %eax,%eax
80100bfb:	74 5d                	je     80100c5a <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100bfd:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c03:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100c08:	75 50                	jne    80100c5a <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c0a:	83 ec 0c             	sub    $0xc,%esp
80100c0d:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100c13:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100c19:	57                   	push   %edi
80100c1a:	50                   	push   %eax
80100c1b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c21:	e8 da 64 00 00       	call   80107100 <loaduvm>
80100c26:	83 c4 20             	add    $0x20,%esp
80100c29:	85 c0                	test   %eax,%eax
80100c2b:	78 2d                	js     80100c5a <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c2d:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c34:	83 c6 01             	add    $0x1,%esi
80100c37:	83 c3 20             	add    $0x20,%ebx
80100c3a:	39 f0                	cmp    %esi,%eax
80100c3c:	7e 52                	jle    80100c90 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c3e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c44:	6a 20                	push   $0x20
80100c46:	53                   	push   %ebx
80100c47:	50                   	push   %eax
80100c48:	57                   	push   %edi
80100c49:	e8 42 0f 00 00       	call   80101b90 <readi>
80100c4e:	83 c4 10             	add    $0x10,%esp
80100c51:	83 f8 20             	cmp    $0x20,%eax
80100c54:	0f 84 5e ff ff ff    	je     80100bb8 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c5a:	83 ec 0c             	sub    $0xc,%esp
80100c5d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c63:	e8 b8 66 00 00       	call   80107320 <freevm>
  if(ip){
80100c68:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c6b:	83 ec 0c             	sub    $0xc,%esp
80100c6e:	57                   	push   %edi
80100c6f:	e8 9c 0e 00 00       	call   80101b10 <iunlockput>
    end_op();
80100c74:	e8 d7 22 00 00       	call   80102f50 <end_op>
80100c79:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c84:	5b                   	pop    %ebx
80100c85:	5e                   	pop    %esi
80100c86:	5f                   	pop    %edi
80100c87:	5d                   	pop    %ebp
80100c88:	c3                   	ret
80100c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c90:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c96:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c9c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ca2:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100ca8:	83 ec 0c             	sub    $0xc,%esp
80100cab:	57                   	push   %edi
80100cac:	e8 5f 0e 00 00       	call   80101b10 <iunlockput>
  end_op();
80100cb1:	e8 9a 22 00 00       	call   80102f50 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cb6:	83 c4 0c             	add    $0xc,%esp
80100cb9:	53                   	push   %ebx
80100cba:	56                   	push   %esi
80100cbb:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100cc1:	56                   	push   %esi
80100cc2:	e8 09 65 00 00       	call   801071d0 <allocuvm>
80100cc7:	83 c4 10             	add    $0x10,%esp
80100cca:	89 c7                	mov    %eax,%edi
80100ccc:	85 c0                	test   %eax,%eax
80100cce:	0f 84 86 00 00 00    	je     80100d5a <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd4:	83 ec 08             	sub    $0x8,%esp
80100cd7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100cdd:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cdf:	50                   	push   %eax
80100ce0:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100ce1:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ce3:	e8 58 67 00 00       	call   80107440 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ceb:	83 c4 10             	add    $0x10,%esp
80100cee:	8b 10                	mov    (%eax),%edx
80100cf0:	85 d2                	test   %edx,%edx
80100cf2:	0f 84 56 01 00 00    	je     80100e4e <exec+0x33e>
80100cf8:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100cfe:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100d01:	eb 23                	jmp    80100d26 <exec+0x216>
80100d03:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100d08:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100d0b:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100d12:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100d18:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100d1b:	85 d2                	test   %edx,%edx
80100d1d:	74 51                	je     80100d70 <exec+0x260>
    if(argc >= MAXARG)
80100d1f:	83 f8 20             	cmp    $0x20,%eax
80100d22:	74 36                	je     80100d5a <exec+0x24a>
80100d24:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d26:	83 ec 0c             	sub    $0xc,%esp
80100d29:	52                   	push   %edx
80100d2a:	e8 d1 3f 00 00       	call   80104d00 <strlen>
80100d2f:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d31:	58                   	pop    %eax
80100d32:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d35:	83 eb 01             	sub    $0x1,%ebx
80100d38:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d3b:	e8 c0 3f 00 00       	call   80104d00 <strlen>
80100d40:	83 c0 01             	add    $0x1,%eax
80100d43:	50                   	push   %eax
80100d44:	ff 34 b7             	push   (%edi,%esi,4)
80100d47:	53                   	push   %ebx
80100d48:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d4e:	e8 ad 68 00 00       	call   80107600 <copyout>
80100d53:	83 c4 20             	add    $0x20,%esp
80100d56:	85 c0                	test   %eax,%eax
80100d58:	79 ae                	jns    80100d08 <exec+0x1f8>
    freevm(pgdir);
80100d5a:	83 ec 0c             	sub    $0xc,%esp
80100d5d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d63:	e8 b8 65 00 00       	call   80107320 <freevm>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	e9 0c ff ff ff       	jmp    80100c7c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d70:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d77:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d7d:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100d83:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d86:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d89:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d90:	00 00 00 00 
  ustack[1] = argc;
80100d94:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d9a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100da1:	ff ff ff 
  ustack[1] = argc;
80100da4:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100daa:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100dac:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dae:	29 d0                	sub    %edx,%eax
80100db0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100db6:	56                   	push   %esi
80100db7:	51                   	push   %ecx
80100db8:	53                   	push   %ebx
80100db9:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100dbf:	e8 3c 68 00 00       	call   80107600 <copyout>
80100dc4:	83 c4 10             	add    $0x10,%esp
80100dc7:	85 c0                	test   %eax,%eax
80100dc9:	78 8f                	js     80100d5a <exec+0x24a>
  for(last=s=path; *s; s++)
80100dcb:	8b 45 08             	mov    0x8(%ebp),%eax
80100dce:	8b 55 08             	mov    0x8(%ebp),%edx
80100dd1:	0f b6 00             	movzbl (%eax),%eax
80100dd4:	84 c0                	test   %al,%al
80100dd6:	74 17                	je     80100def <exec+0x2df>
80100dd8:	89 d1                	mov    %edx,%ecx
80100dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100de0:	83 c1 01             	add    $0x1,%ecx
80100de3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100de5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100de8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100deb:	84 c0                	test   %al,%al
80100ded:	75 f1                	jne    80100de0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100def:	83 ec 04             	sub    $0x4,%esp
80100df2:	6a 10                	push   $0x10
80100df4:	52                   	push   %edx
80100df5:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100dfb:	8d 46 6c             	lea    0x6c(%esi),%eax
80100dfe:	50                   	push   %eax
80100dff:	e8 ac 3e 00 00       	call   80104cb0 <safestrcpy>
  curproc->pgdir = pgdir;
80100e04:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100e0a:	89 f0                	mov    %esi,%eax
80100e0c:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100e0f:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100e11:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100e14:	89 c1                	mov    %eax,%ecx
80100e16:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100e1c:	8b 40 18             	mov    0x18(%eax),%eax
80100e1f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e22:	8b 41 18             	mov    0x18(%ecx),%eax
80100e25:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100e28:	89 0c 24             	mov    %ecx,(%esp)
80100e2b:	e8 40 61 00 00       	call   80106f70 <switchuvm>
  freevm(oldpgdir);
80100e30:	89 34 24             	mov    %esi,(%esp)
80100e33:	e8 e8 64 00 00       	call   80107320 <freevm>
  return 0;
80100e38:	83 c4 10             	add    $0x10,%esp
80100e3b:	31 c0                	xor    %eax,%eax
80100e3d:	e9 3f fe ff ff       	jmp    80100c81 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e42:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100e47:	31 f6                	xor    %esi,%esi
80100e49:	e9 5a fe ff ff       	jmp    80100ca8 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100e4e:	be 10 00 00 00       	mov    $0x10,%esi
80100e53:	ba 04 00 00 00       	mov    $0x4,%edx
80100e58:	b8 03 00 00 00       	mov    $0x3,%eax
80100e5d:	c7 85 e8 fe ff ff 00 	movl   $0x0,-0x118(%ebp)
80100e64:	00 00 00 
80100e67:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e6d:	e9 17 ff ff ff       	jmp    80100d89 <exec+0x279>
    end_op();
80100e72:	e8 d9 20 00 00       	call   80102f50 <end_op>
    cprintf("exec: fail\n");
80100e77:	83 ec 0c             	sub    $0xc,%esp
80100e7a:	68 50 77 10 80       	push   $0x80107750
80100e7f:	e8 4c f8 ff ff       	call   801006d0 <cprintf>
    return -1;
80100e84:	83 c4 10             	add    $0x10,%esp
80100e87:	e9 f0 fd ff ff       	jmp    80100c7c <exec+0x16c>
80100e8c:	66 90                	xchg   %ax,%ax
80100e8e:	66 90                	xchg   %ax,%ax
80100e90:	66 90                	xchg   %ax,%ax
80100e92:	66 90                	xchg   %ax,%ax
80100e94:	66 90                	xchg   %ax,%ax
80100e96:	66 90                	xchg   %ax,%ax
80100e98:	66 90                	xchg   %ax,%ax
80100e9a:	66 90                	xchg   %ax,%ax
80100e9c:	66 90                	xchg   %ax,%ax
80100e9e:	66 90                	xchg   %ax,%ax

80100ea0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100ea6:	68 5c 77 10 80       	push   $0x8010775c
80100eab:	68 60 ff 10 80       	push   $0x8010ff60
80100eb0:	e8 0b 39 00 00       	call   801047c0 <initlock>
}
80100eb5:	83 c4 10             	add    $0x10,%esp
80100eb8:	c9                   	leave
80100eb9:	c3                   	ret
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ec0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ec4:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100ec9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100ecc:	68 60 ff 10 80       	push   $0x8010ff60
80100ed1:	e8 0a 3b 00 00       	call   801049e0 <acquire>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb 10                	jmp    80100eeb <filealloc+0x2b>
80100edb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ee0:	83 c3 18             	add    $0x18,%ebx
80100ee3:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100ee9:	74 25                	je     80100f10 <filealloc+0x50>
    if(f->ref == 0){
80100eeb:	8b 43 04             	mov    0x4(%ebx),%eax
80100eee:	85 c0                	test   %eax,%eax
80100ef0:	75 ee                	jne    80100ee0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100ef2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100ef5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100efc:	68 60 ff 10 80       	push   $0x8010ff60
80100f01:	e8 7a 3a 00 00       	call   80104980 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100f06:	89 d8                	mov    %ebx,%eax
      return f;
80100f08:	83 c4 10             	add    $0x10,%esp
}
80100f0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f0e:	c9                   	leave
80100f0f:	c3                   	ret
  release(&ftable.lock);
80100f10:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100f13:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100f15:	68 60 ff 10 80       	push   $0x8010ff60
80100f1a:	e8 61 3a 00 00       	call   80104980 <release>
}
80100f1f:	89 d8                	mov    %ebx,%eax
  return 0;
80100f21:	83 c4 10             	add    $0x10,%esp
}
80100f24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f27:	c9                   	leave
80100f28:	c3                   	ret
80100f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f30 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	53                   	push   %ebx
80100f34:	83 ec 10             	sub    $0x10,%esp
80100f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f3a:	68 60 ff 10 80       	push   $0x8010ff60
80100f3f:	e8 9c 3a 00 00       	call   801049e0 <acquire>
  if(f->ref < 1)
80100f44:	8b 43 04             	mov    0x4(%ebx),%eax
80100f47:	83 c4 10             	add    $0x10,%esp
80100f4a:	85 c0                	test   %eax,%eax
80100f4c:	7e 1a                	jle    80100f68 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f4e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f51:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f54:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f57:	68 60 ff 10 80       	push   $0x8010ff60
80100f5c:	e8 1f 3a 00 00       	call   80104980 <release>
  return f;
}
80100f61:	89 d8                	mov    %ebx,%eax
80100f63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f66:	c9                   	leave
80100f67:	c3                   	ret
    panic("filedup");
80100f68:	83 ec 0c             	sub    $0xc,%esp
80100f6b:	68 63 77 10 80       	push   $0x80107763
80100f70:	e8 2b f4 ff ff       	call   801003a0 <panic>
80100f75:	8d 76 00             	lea    0x0(%esi),%esi
80100f78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f7f:	00 

80100f80 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f80:	55                   	push   %ebp
80100f81:	89 e5                	mov    %esp,%ebp
80100f83:	57                   	push   %edi
80100f84:	56                   	push   %esi
80100f85:	53                   	push   %ebx
80100f86:	83 ec 28             	sub    $0x28,%esp
80100f89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f8c:	68 60 ff 10 80       	push   $0x8010ff60
80100f91:	e8 4a 3a 00 00       	call   801049e0 <acquire>
  if(f->ref < 1)
80100f96:	8b 43 04             	mov    0x4(%ebx),%eax
80100f99:	83 c4 10             	add    $0x10,%esp
80100f9c:	85 c0                	test   %eax,%eax
80100f9e:	0f 8e a8 00 00 00    	jle    8010104c <fileclose+0xcc>
    panic("fileclose");
  if(--f->ref > 0){
80100fa4:	83 e8 01             	sub    $0x1,%eax
80100fa7:	89 43 04             	mov    %eax,0x4(%ebx)
80100faa:	75 44                	jne    80100ff0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100fac:	8b 43 0c             	mov    0xc(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100faf:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100fb2:	8b 33                	mov    (%ebx),%esi
  f->type = FD_NONE;
80100fb4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100fba:	0f b6 7b 09          	movzbl 0x9(%ebx),%edi
80100fbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100fc1:	8b 43 10             	mov    0x10(%ebx),%eax
80100fc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100fc7:	68 60 ff 10 80       	push   $0x8010ff60
80100fcc:	e8 af 39 00 00       	call   80104980 <release>

  if(ff.type == FD_PIPE)
80100fd1:	83 c4 10             	add    $0x10,%esp
80100fd4:	83 fe 01             	cmp    $0x1,%esi
80100fd7:	74 57                	je     80101030 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100fd9:	83 fe 02             	cmp    $0x2,%esi
80100fdc:	74 2a                	je     80101008 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100fde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe1:	5b                   	pop    %ebx
80100fe2:	5e                   	pop    %esi
80100fe3:	5f                   	pop    %edi
80100fe4:	5d                   	pop    %ebp
80100fe5:	c3                   	ret
80100fe6:	66 90                	xchg   %ax,%ax
80100fe8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fef:	00 
    release(&ftable.lock);
80100ff0:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100ff7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ffa:	5b                   	pop    %ebx
80100ffb:	5e                   	pop    %esi
80100ffc:	5f                   	pop    %edi
80100ffd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100ffe:	e9 7d 39 00 00       	jmp    80104980 <release>
80101003:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80101008:	e8 d3 1e 00 00       	call   80102ee0 <begin_op>
    iput(ff.ip);
8010100d:	83 ec 0c             	sub    $0xc,%esp
80101010:	ff 75 e0             	push   -0x20(%ebp)
80101013:	e8 88 09 00 00       	call   801019a0 <iput>
    end_op();
80101018:	83 c4 10             	add    $0x10,%esp
}
8010101b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010101e:	5b                   	pop    %ebx
8010101f:	5e                   	pop    %esi
80101020:	5f                   	pop    %edi
80101021:	5d                   	pop    %ebp
    end_op();
80101022:	e9 29 1f 00 00       	jmp    80102f50 <end_op>
80101027:	90                   	nop
80101028:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010102f:	00 
    pipeclose(ff.pipe, ff.writable);
80101030:	89 f8                	mov    %edi,%eax
80101032:	83 ec 08             	sub    $0x8,%esp
80101035:	0f be c0             	movsbl %al,%eax
80101038:	50                   	push   %eax
80101039:	ff 75 e4             	push   -0x1c(%ebp)
8010103c:	e8 6f 26 00 00       	call   801036b0 <pipeclose>
80101041:	83 c4 10             	add    $0x10,%esp
}
80101044:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101047:	5b                   	pop    %ebx
80101048:	5e                   	pop    %esi
80101049:	5f                   	pop    %edi
8010104a:	5d                   	pop    %ebp
8010104b:	c3                   	ret
    panic("fileclose");
8010104c:	83 ec 0c             	sub    $0xc,%esp
8010104f:	68 6b 77 10 80       	push   $0x8010776b
80101054:	e8 47 f3 ff ff       	call   801003a0 <panic>
80101059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101060 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101060:	55                   	push   %ebp
80101061:	89 e5                	mov    %esp,%ebp
80101063:	53                   	push   %ebx
80101064:	83 ec 04             	sub    $0x4,%esp
80101067:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010106a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010106d:	75 31                	jne    801010a0 <filestat+0x40>
    ilock(f->ip);
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	ff 73 10             	push   0x10(%ebx)
80101075:	e8 f6 07 00 00       	call   80101870 <ilock>
    stati(f->ip, st);
8010107a:	58                   	pop    %eax
8010107b:	5a                   	pop    %edx
8010107c:	ff 75 0c             	push   0xc(%ebp)
8010107f:	ff 73 10             	push   0x10(%ebx)
80101082:	e8 d9 0a 00 00       	call   80101b60 <stati>
    iunlock(f->ip);
80101087:	59                   	pop    %ecx
80101088:	ff 73 10             	push   0x10(%ebx)
8010108b:	e8 c0 08 00 00       	call   80101950 <iunlock>
    return 0;
  }
  return -1;
}
80101090:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101093:	83 c4 10             	add    $0x10,%esp
80101096:	31 c0                	xor    %eax,%eax
}
80101098:	c9                   	leave
80101099:	c3                   	ret
8010109a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801010a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801010a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010a8:	c9                   	leave
801010a9:	c3                   	ret
801010aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801010b0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 0c             	sub    $0xc,%esp
801010b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bc:	8b 75 0c             	mov    0xc(%ebp),%esi
801010bf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801010c2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801010c6:	74 60                	je     80101128 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801010c8:	8b 03                	mov    (%ebx),%eax
801010ca:	83 f8 01             	cmp    $0x1,%eax
801010cd:	74 41                	je     80101110 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010cf:	83 f8 02             	cmp    $0x2,%eax
801010d2:	75 5b                	jne    8010112f <fileread+0x7f>
    ilock(f->ip);
801010d4:	83 ec 0c             	sub    $0xc,%esp
801010d7:	ff 73 10             	push   0x10(%ebx)
801010da:	e8 91 07 00 00       	call   80101870 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010df:	57                   	push   %edi
801010e0:	ff 73 14             	push   0x14(%ebx)
801010e3:	56                   	push   %esi
801010e4:	ff 73 10             	push   0x10(%ebx)
801010e7:	e8 a4 0a 00 00       	call   80101b90 <readi>
801010ec:	83 c4 20             	add    $0x20,%esp
801010ef:	89 c6                	mov    %eax,%esi
801010f1:	85 c0                	test   %eax,%eax
801010f3:	7e 03                	jle    801010f8 <fileread+0x48>
      f->off += r;
801010f5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010f8:	83 ec 0c             	sub    $0xc,%esp
801010fb:	ff 73 10             	push   0x10(%ebx)
801010fe:	e8 4d 08 00 00       	call   80101950 <iunlock>
    return r;
80101103:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101106:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101109:	89 f0                	mov    %esi,%eax
8010110b:	5b                   	pop    %ebx
8010110c:	5e                   	pop    %esi
8010110d:	5f                   	pop    %edi
8010110e:	5d                   	pop    %ebp
8010110f:	c3                   	ret
    return piperead(f->pipe, addr, n);
80101110:	8b 43 0c             	mov    0xc(%ebx),%eax
80101113:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101116:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101119:	5b                   	pop    %ebx
8010111a:	5e                   	pop    %esi
8010111b:	5f                   	pop    %edi
8010111c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010111d:	e9 3e 27 00 00       	jmp    80103860 <piperead>
80101122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101128:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010112d:	eb d7                	jmp    80101106 <fileread+0x56>
  panic("fileread");
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	68 75 77 10 80       	push   $0x80107775
80101137:	e8 64 f2 ff ff       	call   801003a0 <panic>
8010113c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101140 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101140:	55                   	push   %ebp
80101141:	89 e5                	mov    %esp,%ebp
80101143:	57                   	push   %edi
80101144:	56                   	push   %esi
80101145:	53                   	push   %ebx
80101146:	83 ec 1c             	sub    $0x1c,%esp
80101149:	8b 45 0c             	mov    0xc(%ebp),%eax
8010114c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010114f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101152:	8b 45 10             	mov    0x10(%ebp),%eax
80101155:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80101158:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
8010115c:	0f 84 b3 00 00 00    	je     80101215 <filewrite+0xd5>
    return -1;
  if(f->type == FD_PIPE)
80101162:	8b 17                	mov    (%edi),%edx
80101164:	83 fa 01             	cmp    $0x1,%edx
80101167:	0f 84 b7 00 00 00    	je     80101224 <filewrite+0xe4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010116d:	83 fa 02             	cmp    $0x2,%edx
80101170:	0f 85 c0 00 00 00    	jne    80101236 <filewrite+0xf6>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101176:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    int i = 0;
80101179:	31 f6                	xor    %esi,%esi
    while(i < n){
8010117b:	85 d2                	test   %edx,%edx
8010117d:	7f 2e                	jg     801011ad <filewrite+0x6d>
8010117f:	e9 8c 00 00 00       	jmp    80101210 <filewrite+0xd0>
80101184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101188:	01 47 14             	add    %eax,0x14(%edi)
      iunlock(f->ip);
8010118b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010118e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101191:	51                   	push   %ecx
80101192:	e8 b9 07 00 00       	call   80101950 <iunlock>
      end_op();
80101197:	e8 b4 1d 00 00       	call   80102f50 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010119c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010119f:	83 c4 10             	add    $0x10,%esp
801011a2:	39 d8                	cmp    %ebx,%eax
801011a4:	75 5d                	jne    80101203 <filewrite+0xc3>
        panic("short filewrite");
      i += r;
801011a6:	01 c6                	add    %eax,%esi
    while(i < n){
801011a8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011ab:	7e 63                	jle    80101210 <filewrite+0xd0>
      int n1 = n - i;
801011ad:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
      if(n1 > max)
801011b0:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
801011b5:	29 f3                	sub    %esi,%ebx
      if(n1 > max)
801011b7:	39 c3                	cmp    %eax,%ebx
801011b9:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801011bc:	e8 1f 1d 00 00       	call   80102ee0 <begin_op>
      ilock(f->ip);
801011c1:	83 ec 0c             	sub    $0xc,%esp
801011c4:	ff 77 10             	push   0x10(%edi)
801011c7:	e8 a4 06 00 00       	call   80101870 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801011cc:	53                   	push   %ebx
801011cd:	ff 77 14             	push   0x14(%edi)
801011d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011d3:	01 f0                	add    %esi,%eax
801011d5:	50                   	push   %eax
801011d6:	ff 77 10             	push   0x10(%edi)
801011d9:	e8 b2 0a 00 00       	call   80101c90 <writei>
      iunlock(f->ip);
801011de:	8b 4f 10             	mov    0x10(%edi),%ecx
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801011e1:	83 c4 20             	add    $0x20,%esp
801011e4:	85 c0                	test   %eax,%eax
801011e6:	7f a0                	jg     80101188 <filewrite+0x48>
      iunlock(f->ip);
801011e8:	83 ec 0c             	sub    $0xc,%esp
801011eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011ee:	51                   	push   %ecx
801011ef:	e8 5c 07 00 00       	call   80101950 <iunlock>
      end_op();
801011f4:	e8 57 1d 00 00       	call   80102f50 <end_op>
      if(r < 0)
801011f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011fc:	83 c4 10             	add    $0x10,%esp
801011ff:	85 c0                	test   %eax,%eax
80101201:	75 0d                	jne    80101210 <filewrite+0xd0>
        panic("short filewrite");
80101203:	83 ec 0c             	sub    $0xc,%esp
80101206:	68 7e 77 10 80       	push   $0x8010777e
8010120b:	e8 90 f1 ff ff       	call   801003a0 <panic>
    }
    return i == n ? n : -1;
80101210:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80101213:	74 05                	je     8010121a <filewrite+0xda>
    return -1;
80101215:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
8010121a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010121d:	89 f0                	mov    %esi,%eax
8010121f:	5b                   	pop    %ebx
80101220:	5e                   	pop    %esi
80101221:	5f                   	pop    %edi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
80101224:	8b 47 0c             	mov    0xc(%edi),%eax
80101227:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010122a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010122d:	5b                   	pop    %ebx
8010122e:	5e                   	pop    %esi
8010122f:	5f                   	pop    %edi
80101230:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101231:	e9 1a 25 00 00       	jmp    80103750 <pipewrite>
  panic("filewrite");
80101236:	83 ec 0c             	sub    $0xc,%esp
80101239:	68 84 77 10 80       	push   $0x80107784
8010123e:	e8 5d f1 ff ff       	call   801003a0 <panic>
80101243:	66 90                	xchg   %ax,%ax
80101245:	66 90                	xchg   %ax,%ax
80101247:	66 90                	xchg   %ax,%ax
80101249:	66 90                	xchg   %ax,%ax
8010124b:	66 90                	xchg   %ax,%ax
8010124d:	66 90                	xchg   %ax,%ax
8010124f:	90                   	nop

80101250 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	56                   	push   %esi
80101255:	53                   	push   %ebx
80101256:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101259:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010125f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101262:	85 c9                	test   %ecx,%ecx
80101264:	0f 84 8a 00 00 00    	je     801012f4 <balloc+0xa4>
8010126a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010126c:	89 f8                	mov    %edi,%eax
8010126e:	83 ec 08             	sub    $0x8,%esp
80101271:	89 fe                	mov    %edi,%esi
80101273:	c1 f8 0c             	sar    $0xc,%eax
80101276:	03 05 cc 25 11 80    	add    0x801125cc,%eax
8010127c:	50                   	push   %eax
8010127d:	ff 75 dc             	push   -0x24(%ebp)
80101280:	e8 4b ee ff ff       	call   801000d0 <bread>
80101285:	83 c4 10             	add    $0x10,%esp
80101288:	89 7d d8             	mov    %edi,-0x28(%ebp)
8010128b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010128e:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101293:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101296:	31 c0                	xor    %eax,%eax
80101298:	eb 32                	jmp    801012cc <balloc+0x7c>
8010129a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012a0:	89 c1                	mov    %eax,%ecx
801012a2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
801012aa:	83 e1 07             	and    $0x7,%ecx
801012ad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012af:	89 c1                	mov    %eax,%ecx
801012b1:	c1 f9 03             	sar    $0x3,%ecx
801012b4:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
801012b9:	89 fa                	mov    %edi,%edx
801012bb:	85 df                	test   %ebx,%edi
801012bd:	74 49                	je     80101308 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012bf:	83 c0 01             	add    $0x1,%eax
801012c2:	83 c6 01             	add    $0x1,%esi
801012c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ca:	74 05                	je     801012d1 <balloc+0x81>
801012cc:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801012cf:	72 cf                	jb     801012a0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801012d1:	8b 7d d8             	mov    -0x28(%ebp),%edi
801012d4:	83 ec 0c             	sub    $0xc,%esp
801012d7:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012da:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801012e0:	e8 1b ef ff ff       	call   80100200 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012e5:	83 c4 10             	add    $0x10,%esp
801012e8:	3b 3d b4 25 11 80    	cmp    0x801125b4,%edi
801012ee:	0f 82 78 ff ff ff    	jb     8010126c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
801012f4:	83 ec 0c             	sub    $0xc,%esp
801012f7:	68 8e 77 10 80       	push   $0x8010778e
801012fc:	e8 9f f0 ff ff       	call   801003a0 <panic>
80101301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101308:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010130b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010130e:	09 da                	or     %ebx,%edx
80101310:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101314:	57                   	push   %edi
80101315:	e8 a6 1d 00 00       	call   801030c0 <log_write>
        brelse(bp);
8010131a:	89 3c 24             	mov    %edi,(%esp)
8010131d:	e8 de ee ff ff       	call   80100200 <brelse>
  bp = bread(dev, bno);
80101322:	58                   	pop    %eax
80101323:	5a                   	pop    %edx
80101324:	56                   	push   %esi
80101325:	ff 75 dc             	push   -0x24(%ebp)
80101328:	e8 a3 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
8010132d:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101330:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101332:	8d 40 5c             	lea    0x5c(%eax),%eax
80101335:	68 00 02 00 00       	push   $0x200
8010133a:	6a 00                	push   $0x0
8010133c:	50                   	push   %eax
8010133d:	e8 be 37 00 00       	call   80104b00 <memset>
  log_write(bp);
80101342:	89 1c 24             	mov    %ebx,(%esp)
80101345:	e8 76 1d 00 00       	call   801030c0 <log_write>
  brelse(bp);
8010134a:	89 1c 24             	mov    %ebx,(%esp)
8010134d:	e8 ae ee ff ff       	call   80100200 <brelse>
}
80101352:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101355:	89 f0                	mov    %esi,%eax
80101357:	5b                   	pop    %ebx
80101358:	5e                   	pop    %esi
80101359:	5f                   	pop    %edi
8010135a:	5d                   	pop    %ebp
8010135b:	c3                   	ret
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	89 d7                	mov    %edx,%edi
80101366:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101367:	31 f6                	xor    %esi,%esi
{
80101369:	53                   	push   %ebx
8010136a:	89 c3                	mov    %eax,%ebx
8010136c:	83 ec 28             	sub    $0x28,%esp
  acquire(&icache.lock);
8010136f:	68 60 09 11 80       	push   $0x80110960
80101374:	e8 67 36 00 00       	call   801049e0 <acquire>
80101379:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137c:	b8 94 09 11 80       	mov    $0x80110994,%eax
80101381:	eb 19                	jmp    8010139c <iget+0x3c>
80101383:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101388:	39 18                	cmp    %ebx,(%eax)
8010138a:	0f 84 b0 00 00 00    	je     80101440 <iget+0xe0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101390:	05 90 00 00 00       	add    $0x90,%eax
80101395:	3d b4 25 11 80       	cmp    $0x801125b4,%eax
8010139a:	74 24                	je     801013c0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010139c:	8b 50 08             	mov    0x8(%eax),%edx
8010139f:	85 d2                	test   %edx,%edx
801013a1:	7f e5                	jg     80101388 <iget+0x28>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013a3:	89 c1                	mov    %eax,%ecx
801013a5:	85 f6                	test   %esi,%esi
801013a7:	75 4f                	jne    801013f8 <iget+0x98>
801013a9:	85 d2                	test   %edx,%edx
801013ab:	0f 85 be 00 00 00    	jne    8010146f <iget+0x10f>
      empty = ip;
801013b1:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013b3:	05 90 00 00 00       	add    $0x90,%eax
801013b8:	3d b4 25 11 80       	cmp    $0x801125b4,%eax
801013bd:	75 dd                	jne    8010139c <iget+0x3c>
801013bf:	90                   	nop
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013c0:	85 f6                	test   %esi,%esi
801013c2:	0f 84 c3 00 00 00    	je     8010148b <iget+0x12b>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013c8:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013cb:	89 1e                	mov    %ebx,(%esi)
  ip->inum = inum;
801013cd:	89 7e 04             	mov    %edi,0x4(%esi)
  ip->ref = 1;
801013d0:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013d7:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013de:	68 60 09 11 80       	push   $0x80110960
801013e3:	e8 98 35 00 00       	call   80104980 <release>

  return ip;
801013e8:	83 c4 10             	add    $0x10,%esp
}
801013eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ee:	89 f0                	mov    %esi,%eax
801013f0:	5b                   	pop    %ebx
801013f1:	5e                   	pop    %esi
801013f2:	5f                   	pop    %edi
801013f3:	5d                   	pop    %ebp
801013f4:	c3                   	ret
801013f5:	8d 76 00             	lea    0x0(%esi),%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013f8:	05 90 00 00 00       	add    $0x90,%eax
801013fd:	3d b4 25 11 80       	cmp    $0x801125b4,%eax
80101402:	74 c4                	je     801013c8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101404:	8b 50 08             	mov    0x8(%eax),%edx
80101407:	85 d2                	test   %edx,%edx
80101409:	0f 8f 79 ff ff ff    	jg     80101388 <iget+0x28>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010140f:	8d 81 20 01 00 00    	lea    0x120(%ecx),%eax
80101415:	81 f9 94 24 11 80    	cmp    $0x80112494,%ecx
8010141b:	74 a3                	je     801013c0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010141d:	8b 50 08             	mov    0x8(%eax),%edx
80101420:	85 d2                	test   %edx,%edx
80101422:	0f 8f 60 ff ff ff    	jg     80101388 <iget+0x28>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101428:	89 c1                	mov    %eax,%ecx
8010142a:	05 90 00 00 00       	add    $0x90,%eax
8010142f:	3d b4 25 11 80       	cmp    $0x801125b4,%eax
80101434:	75 ce                	jne    80101404 <iget+0xa4>
80101436:	eb 90                	jmp    801013c8 <iget+0x68>
80101438:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010143f:	00 
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101440:	39 78 04             	cmp    %edi,0x4(%eax)
80101443:	0f 85 47 ff ff ff    	jne    80101390 <iget+0x30>
      release(&icache.lock);
80101449:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
8010144c:	83 c2 01             	add    $0x1,%edx
8010144f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101452:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101455:	68 60 09 11 80       	push   $0x80110960
8010145a:	e8 21 35 00 00       	call   80104980 <release>
      return ip;
8010145f:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101462:	83 c4 10             	add    $0x10,%esp
}
80101465:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101468:	5b                   	pop    %ebx
80101469:	89 f0                	mov    %esi,%eax
8010146b:	5e                   	pop    %esi
8010146c:	5f                   	pop    %edi
8010146d:	5d                   	pop    %ebp
8010146e:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010146f:	05 90 00 00 00       	add    $0x90,%eax
80101474:	3d b4 25 11 80       	cmp    $0x801125b4,%eax
80101479:	74 10                	je     8010148b <iget+0x12b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010147b:	8b 50 08             	mov    0x8(%eax),%edx
8010147e:	85 d2                	test   %edx,%edx
80101480:	0f 8f 02 ff ff ff    	jg     80101388 <iget+0x28>
80101486:	e9 1e ff ff ff       	jmp    801013a9 <iget+0x49>
    panic("iget: no inodes");
8010148b:	83 ec 0c             	sub    $0xc,%esp
8010148e:	68 a4 77 10 80       	push   $0x801077a4
80101493:	e8 08 ef ff ff       	call   801003a0 <panic>
80101498:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010149f:	00 

801014a0 <bfree>:
{
801014a0:	55                   	push   %ebp
801014a1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
801014a3:	89 d0                	mov    %edx,%eax
801014a5:	c1 e8 0c             	shr    $0xc,%eax
{
801014a8:	89 e5                	mov    %esp,%ebp
801014aa:	56                   	push   %esi
801014ab:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
801014ac:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801014b2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801014b4:	83 ec 08             	sub    $0x8,%esp
801014b7:	50                   	push   %eax
801014b8:	51                   	push   %ecx
801014b9:	e8 12 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014be:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014c0:	c1 fb 03             	sar    $0x3,%ebx
801014c3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801014c6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801014c8:	83 e1 07             	and    $0x7,%ecx
801014cb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801014d0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801014d6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801014d8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801014dd:	85 c1                	test   %eax,%ecx
801014df:	74 23                	je     80101504 <bfree+0x64>
  bp->data[bi/8] &= ~m;
801014e1:	f7 d0                	not    %eax
  log_write(bp);
801014e3:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801014e6:	21 c8                	and    %ecx,%eax
801014e8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801014ec:	56                   	push   %esi
801014ed:	e8 ce 1b 00 00       	call   801030c0 <log_write>
  brelse(bp);
801014f2:	89 34 24             	mov    %esi,(%esp)
801014f5:	e8 06 ed ff ff       	call   80100200 <brelse>
}
801014fa:	83 c4 10             	add    $0x10,%esp
801014fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101500:	5b                   	pop    %ebx
80101501:	5e                   	pop    %esi
80101502:	5d                   	pop    %ebp
80101503:	c3                   	ret
    panic("freeing free block");
80101504:	83 ec 0c             	sub    $0xc,%esp
80101507:	68 b4 77 10 80       	push   $0x801077b4
8010150c:	e8 8f ee ff ff       	call   801003a0 <panic>
80101511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101518:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010151f:	00 

80101520 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	89 c6                	mov    %eax,%esi
80101526:	53                   	push   %ebx
80101527:	83 ec 10             	sub    $0x10,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010152a:	83 fa 0b             	cmp    $0xb,%edx
8010152d:	0f 86 8d 00 00 00    	jbe    801015c0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101533:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101536:	83 fb 7f             	cmp    $0x7f,%ebx
80101539:	0f 87 a8 00 00 00    	ja     801015e7 <bmap+0xc7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
8010153f:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101545:	85 c0                	test   %eax,%eax
80101547:	74 67                	je     801015b0 <bmap+0x90>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101549:	83 ec 08             	sub    $0x8,%esp
8010154c:	50                   	push   %eax
8010154d:	ff 36                	push   (%esi)
8010154f:	e8 7c eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101554:	83 c4 10             	add    $0x10,%esp
80101557:	8d 4c 98 5c          	lea    0x5c(%eax,%ebx,4),%ecx
    bp = bread(ip->dev, addr);
8010155b:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010155d:	8b 19                	mov    (%ecx),%ebx
8010155f:	85 db                	test   %ebx,%ebx
80101561:	74 1d                	je     80101580 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101563:	83 ec 0c             	sub    $0xc,%esp
80101566:	52                   	push   %edx
80101567:	e8 94 ec ff ff       	call   80100200 <brelse>
8010156c:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
8010156f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101572:	89 d8                	mov    %ebx,%eax
80101574:	5b                   	pop    %ebx
80101575:	5e                   	pop    %esi
80101576:	5d                   	pop    %ebp
80101577:	c3                   	ret
80101578:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010157f:	00 
80101580:	89 45 f4             	mov    %eax,-0xc(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101583:	8b 06                	mov    (%esi),%eax
80101585:	89 4d f0             	mov    %ecx,-0x10(%ebp)
80101588:	e8 c3 fc ff ff       	call   80101250 <balloc>
8010158d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
      log_write(bp);
80101590:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101593:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101596:	89 c3                	mov    %eax,%ebx
80101598:	89 01                	mov    %eax,(%ecx)
      log_write(bp);
8010159a:	52                   	push   %edx
8010159b:	e8 20 1b 00 00       	call   801030c0 <log_write>
801015a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015a3:	83 c4 10             	add    $0x10,%esp
801015a6:	eb bb                	jmp    80101563 <bmap+0x43>
801015a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801015af:	00 
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801015b0:	8b 06                	mov    (%esi),%eax
801015b2:	e8 99 fc ff ff       	call   80101250 <balloc>
801015b7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801015bd:	eb 8a                	jmp    80101549 <bmap+0x29>
801015bf:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
801015c0:	83 c2 14             	add    $0x14,%edx
801015c3:	8b 5c 90 0c          	mov    0xc(%eax,%edx,4),%ebx
801015c7:	85 db                	test   %ebx,%ebx
801015c9:	75 a4                	jne    8010156f <bmap+0x4f>
      ip->addrs[bn] = addr = balloc(ip->dev);
801015cb:	8b 00                	mov    (%eax),%eax
801015cd:	89 55 f4             	mov    %edx,-0xc(%ebp)
801015d0:	e8 7b fc ff ff       	call   80101250 <balloc>
801015d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015d8:	89 c3                	mov    %eax,%ebx
801015da:	89 44 96 0c          	mov    %eax,0xc(%esi,%edx,4)
}
801015de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015e1:	89 d8                	mov    %ebx,%eax
801015e3:	5b                   	pop    %ebx
801015e4:	5e                   	pop    %esi
801015e5:	5d                   	pop    %ebp
801015e6:	c3                   	ret
  panic("bmap: out of range");
801015e7:	83 ec 0c             	sub    $0xc,%esp
801015ea:	68 c7 77 10 80       	push   $0x801077c7
801015ef:	e8 ac ed ff ff       	call   801003a0 <panic>
801015f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801015ff:	00 

80101600 <readsb>:
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	56                   	push   %esi
80101604:	53                   	push   %ebx
80101605:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101608:	83 ec 08             	sub    $0x8,%esp
8010160b:	6a 01                	push   $0x1
8010160d:	ff 75 08             	push   0x8(%ebp)
80101610:	e8 bb ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101615:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101618:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010161a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010161d:	6a 1c                	push   $0x1c
8010161f:	50                   	push   %eax
80101620:	56                   	push   %esi
80101621:	e8 6a 35 00 00       	call   80104b90 <memmove>
  brelse(bp);
80101626:	83 c4 10             	add    $0x10,%esp
80101629:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010162c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010162f:	5b                   	pop    %ebx
80101630:	5e                   	pop    %esi
80101631:	5d                   	pop    %ebp
  brelse(bp);
80101632:	e9 c9 eb ff ff       	jmp    80100200 <brelse>
80101637:	90                   	nop
80101638:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010163f:	00 

80101640 <iinit>:
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	53                   	push   %ebx
80101644:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101649:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010164c:	68 da 77 10 80       	push   $0x801077da
80101651:	68 60 09 11 80       	push   $0x80110960
80101656:	e8 65 31 00 00       	call   801047c0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010165b:	83 c4 10             	add    $0x10,%esp
8010165e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101660:	83 ec 08             	sub    $0x8,%esp
80101663:	68 e1 77 10 80       	push   $0x801077e1
80101668:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101669:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010166f:	e8 1c 30 00 00       	call   80104690 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101674:	83 c4 10             	add    $0x10,%esp
80101677:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010167d:	75 e1                	jne    80101660 <iinit+0x20>
  bp = bread(dev, 1);
8010167f:	83 ec 08             	sub    $0x8,%esp
80101682:	6a 01                	push   $0x1
80101684:	ff 75 08             	push   0x8(%ebp)
80101687:	e8 44 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010168c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010168f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101691:	8d 40 5c             	lea    0x5c(%eax),%eax
80101694:	6a 1c                	push   $0x1c
80101696:	50                   	push   %eax
80101697:	68 b4 25 11 80       	push   $0x801125b4
8010169c:	e8 ef 34 00 00       	call   80104b90 <memmove>
  brelse(bp);
801016a1:	89 1c 24             	mov    %ebx,(%esp)
801016a4:	e8 57 eb ff ff       	call   80100200 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016a9:	ff 35 cc 25 11 80    	push   0x801125cc
801016af:	ff 35 c8 25 11 80    	push   0x801125c8
801016b5:	ff 35 c4 25 11 80    	push   0x801125c4
801016bb:	ff 35 c0 25 11 80    	push   0x801125c0
801016c1:	ff 35 bc 25 11 80    	push   0x801125bc
801016c7:	ff 35 b8 25 11 80    	push   0x801125b8
801016cd:	ff 35 b4 25 11 80    	push   0x801125b4
801016d3:	68 f4 7b 10 80       	push   $0x80107bf4
801016d8:	e8 f3 ef ff ff       	call   801006d0 <cprintf>
}
801016dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016e0:	83 c4 30             	add    $0x30,%esp
801016e3:	c9                   	leave
801016e4:	c3                   	ret
801016e5:	8d 76 00             	lea    0x0(%esi),%esi
801016e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801016ef:	00 

801016f0 <ialloc>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	57                   	push   %edi
801016f4:	56                   	push   %esi
801016f5:	53                   	push   %ebx
801016f6:	83 ec 1c             	sub    $0x1c,%esp
801016f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801016fc:	8b 75 08             	mov    0x8(%ebp),%esi
801016ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101702:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
80101709:	0f 86 91 00 00 00    	jbe    801017a0 <ialloc+0xb0>
8010170f:	bf 01 00 00 00       	mov    $0x1,%edi
80101714:	eb 21                	jmp    80101737 <ialloc+0x47>
80101716:	66 90                	xchg   %ax,%ax
80101718:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010171f:	00 
    brelse(bp);
80101720:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101723:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101726:	53                   	push   %ebx
80101727:	e8 d4 ea ff ff       	call   80100200 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010172c:	83 c4 10             	add    $0x10,%esp
8010172f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101735:	73 69                	jae    801017a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101737:	89 f8                	mov    %edi,%eax
80101739:	83 ec 08             	sub    $0x8,%esp
8010173c:	c1 e8 03             	shr    $0x3,%eax
8010173f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101745:	50                   	push   %eax
80101746:	56                   	push   %esi
80101747:	e8 84 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010174c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010174f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101751:	89 f8                	mov    %edi,%eax
80101753:	83 e0 07             	and    $0x7,%eax
80101756:	c1 e0 06             	shl    $0x6,%eax
80101759:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010175d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101761:	75 bd                	jne    80101720 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101763:	83 ec 04             	sub    $0x4,%esp
80101766:	6a 40                	push   $0x40
80101768:	6a 00                	push   $0x0
8010176a:	51                   	push   %ecx
8010176b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010176e:	e8 8d 33 00 00       	call   80104b00 <memset>
      dip->type = type;
80101773:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101777:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010177a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010177d:	89 1c 24             	mov    %ebx,(%esp)
80101780:	e8 3b 19 00 00       	call   801030c0 <log_write>
      brelse(bp);
80101785:	89 1c 24             	mov    %ebx,(%esp)
80101788:	e8 73 ea ff ff       	call   80100200 <brelse>
      return iget(dev, inum);
8010178d:	83 c4 10             	add    $0x10,%esp
}
80101790:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101793:	89 fa                	mov    %edi,%edx
}
80101795:	5b                   	pop    %ebx
      return iget(dev, inum);
80101796:	89 f0                	mov    %esi,%eax
}
80101798:	5e                   	pop    %esi
80101799:	5f                   	pop    %edi
8010179a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010179b:	e9 c0 fb ff ff       	jmp    80101360 <iget>
  panic("ialloc: no inodes");
801017a0:	83 ec 0c             	sub    $0xc,%esp
801017a3:	68 e7 77 10 80       	push   $0x801077e7
801017a8:	e8 f3 eb ff ff       	call   801003a0 <panic>
801017ad:	8d 76 00             	lea    0x0(%esi),%esi

801017b0 <iupdate>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	56                   	push   %esi
801017b4:	53                   	push   %ebx
801017b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017b8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017bb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017be:	83 ec 08             	sub    $0x8,%esp
801017c1:	c1 e8 03             	shr    $0x3,%eax
801017c4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017ca:	50                   	push   %eax
801017cb:	ff 73 a4             	push   -0x5c(%ebx)
801017ce:	e8 fd e8 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801017d3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
  dip->type = ip->type;
801017e5:	66 89 54 06 5c       	mov    %dx,0x5c(%esi,%eax,1)
  dip->major = ip->major;
801017ea:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
801017ee:	66 89 54 06 5e       	mov    %dx,0x5e(%esi,%eax,1)
  dip->minor = ip->minor;
801017f3:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801017f7:	66 89 54 06 60       	mov    %dx,0x60(%esi,%eax,1)
  dip->nlink = ip->nlink;
801017fc:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101800:	66 89 54 06 62       	mov    %dx,0x62(%esi,%eax,1)
  dip->size = ip->size;
80101805:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101808:	89 54 06 64          	mov    %edx,0x64(%esi,%eax,1)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010180c:	8d 44 06 68          	lea    0x68(%esi,%eax,1),%eax
80101810:	6a 34                	push   $0x34
80101812:	53                   	push   %ebx
80101813:	50                   	push   %eax
80101814:	e8 77 33 00 00       	call   80104b90 <memmove>
  log_write(bp);
80101819:	89 34 24             	mov    %esi,(%esp)
8010181c:	e8 9f 18 00 00       	call   801030c0 <log_write>
  brelse(bp);
80101821:	83 c4 10             	add    $0x10,%esp
80101824:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101827:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010182a:	5b                   	pop    %ebx
8010182b:	5e                   	pop    %esi
8010182c:	5d                   	pop    %ebp
  brelse(bp);
8010182d:	e9 ce e9 ff ff       	jmp    80100200 <brelse>
80101832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101838:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010183f:	00 

80101840 <idup>:
{
80101840:	55                   	push   %ebp
80101841:	89 e5                	mov    %esp,%ebp
80101843:	53                   	push   %ebx
80101844:	83 ec 10             	sub    $0x10,%esp
80101847:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010184a:	68 60 09 11 80       	push   $0x80110960
8010184f:	e8 8c 31 00 00       	call   801049e0 <acquire>
  ip->ref++;
80101854:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101858:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010185f:	e8 1c 31 00 00       	call   80104980 <release>
}
80101864:	89 d8                	mov    %ebx,%eax
80101866:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101869:	c9                   	leave
8010186a:	c3                   	ret
8010186b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101870 <ilock>:
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	53                   	push   %ebx
80101874:	83 ec 14             	sub    $0x14,%esp
80101877:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010187a:	85 db                	test   %ebx,%ebx
8010187c:	0f 84 bb 00 00 00    	je     8010193d <ilock+0xcd>
80101882:	8b 53 08             	mov    0x8(%ebx),%edx
80101885:	85 d2                	test   %edx,%edx
80101887:	0f 8e b0 00 00 00    	jle    8010193d <ilock+0xcd>
  acquiresleep(&ip->lock);
8010188d:	83 ec 0c             	sub    $0xc,%esp
80101890:	8d 43 0c             	lea    0xc(%ebx),%eax
80101893:	50                   	push   %eax
80101894:	e8 37 2e 00 00       	call   801046d0 <acquiresleep>
  if(ip->valid == 0){
80101899:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010189c:	83 c4 10             	add    $0x10,%esp
8010189f:	85 c0                	test   %eax,%eax
801018a1:	74 0d                	je     801018b0 <ilock+0x40>
}
801018a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018a6:	c9                   	leave
801018a7:	c3                   	ret
801018a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018af:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018b0:	8b 43 04             	mov    0x4(%ebx),%eax
801018b3:	83 ec 08             	sub    $0x8,%esp
801018b6:	c1 e8 03             	shr    $0x3,%eax
801018b9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801018bf:	50                   	push   %eax
801018c0:	ff 33                	push   (%ebx)
801018c2:	e8 09 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018c7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018ca:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018cc:	8b 43 04             	mov    0x4(%ebx),%eax
801018cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
801018d2:	83 e0 07             	and    $0x7,%eax
801018d5:	c1 e0 06             	shl    $0x6,%eax
801018d8:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    ip->type = dip->type;
801018dc:	0f b7 08             	movzwl (%eax),%ecx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018df:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801018e2:	66 89 4b 50          	mov    %cx,0x50(%ebx)
    ip->major = dip->major;
801018e6:	0f b7 48 f6          	movzwl -0xa(%eax),%ecx
801018ea:	66 89 4b 52          	mov    %cx,0x52(%ebx)
    ip->minor = dip->minor;
801018ee:	0f b7 48 f8          	movzwl -0x8(%eax),%ecx
801018f2:	66 89 4b 54          	mov    %cx,0x54(%ebx)
    ip->nlink = dip->nlink;
801018f6:	0f b7 48 fa          	movzwl -0x6(%eax),%ecx
801018fa:	66 89 4b 56          	mov    %cx,0x56(%ebx)
    ip->size = dip->size;
801018fe:	8b 48 fc             	mov    -0x4(%eax),%ecx
80101901:	89 4b 58             	mov    %ecx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101904:	6a 34                	push   $0x34
80101906:	50                   	push   %eax
80101907:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010190a:	50                   	push   %eax
8010190b:	e8 80 32 00 00       	call   80104b90 <memmove>
    brelse(bp);
80101910:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101913:	89 14 24             	mov    %edx,(%esp)
80101916:	e8 e5 e8 ff ff       	call   80100200 <brelse>
    ip->valid = 1;
8010191b:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101922:	83 c4 10             	add    $0x10,%esp
80101925:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
8010192a:	0f 85 73 ff ff ff    	jne    801018a3 <ilock+0x33>
      panic("ilock: no type");
80101930:	83 ec 0c             	sub    $0xc,%esp
80101933:	68 ff 77 10 80       	push   $0x801077ff
80101938:	e8 63 ea ff ff       	call   801003a0 <panic>
    panic("ilock");
8010193d:	83 ec 0c             	sub    $0xc,%esp
80101940:	68 f9 77 10 80       	push   $0x801077f9
80101945:	e8 56 ea ff ff       	call   801003a0 <panic>
8010194a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101950 <iunlock>:
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	56                   	push   %esi
80101954:	53                   	push   %ebx
80101955:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101958:	85 db                	test   %ebx,%ebx
8010195a:	74 28                	je     80101984 <iunlock+0x34>
8010195c:	83 ec 0c             	sub    $0xc,%esp
8010195f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101962:	56                   	push   %esi
80101963:	e8 08 2e 00 00       	call   80104770 <holdingsleep>
80101968:	83 c4 10             	add    $0x10,%esp
8010196b:	85 c0                	test   %eax,%eax
8010196d:	74 15                	je     80101984 <iunlock+0x34>
8010196f:	8b 43 08             	mov    0x8(%ebx),%eax
80101972:	85 c0                	test   %eax,%eax
80101974:	7e 0e                	jle    80101984 <iunlock+0x34>
  releasesleep(&ip->lock);
80101976:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101979:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010197c:	5b                   	pop    %ebx
8010197d:	5e                   	pop    %esi
8010197e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010197f:	e9 ac 2d 00 00       	jmp    80104730 <releasesleep>
    panic("iunlock");
80101984:	83 ec 0c             	sub    $0xc,%esp
80101987:	68 0e 78 10 80       	push   $0x8010780e
8010198c:	e8 0f ea ff ff       	call   801003a0 <panic>
80101991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101998:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010199f:	00 

801019a0 <iput>:
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	57                   	push   %edi
801019a4:	56                   	push   %esi
801019a5:	53                   	push   %ebx
801019a6:	83 ec 28             	sub    $0x28,%esp
801019a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801019ac:	8d 73 0c             	lea    0xc(%ebx),%esi
801019af:	56                   	push   %esi
801019b0:	e8 1b 2d 00 00       	call   801046d0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801019b5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801019b8:	83 c4 10             	add    $0x10,%esp
801019bb:	85 d2                	test   %edx,%edx
801019bd:	74 07                	je     801019c6 <iput+0x26>
801019bf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801019c4:	74 32                	je     801019f8 <iput+0x58>
  releasesleep(&ip->lock);
801019c6:	83 ec 0c             	sub    $0xc,%esp
801019c9:	56                   	push   %esi
801019ca:	e8 61 2d 00 00       	call   80104730 <releasesleep>
  acquire(&icache.lock);
801019cf:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801019d6:	e8 05 30 00 00       	call   801049e0 <acquire>
  ip->ref--;
801019db:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801019df:	83 c4 10             	add    $0x10,%esp
801019e2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
801019e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019ec:	5b                   	pop    %ebx
801019ed:	5e                   	pop    %esi
801019ee:	5f                   	pop    %edi
801019ef:	5d                   	pop    %ebp
  release(&icache.lock);
801019f0:	e9 8b 2f 00 00       	jmp    80104980 <release>
801019f5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801019f8:	83 ec 0c             	sub    $0xc,%esp
801019fb:	68 60 09 11 80       	push   $0x80110960
80101a00:	e8 db 2f 00 00       	call   801049e0 <acquire>
    int r = ip->ref;
80101a05:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
80101a08:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101a0f:	e8 6c 2f 00 00       	call   80104980 <release>
    if(r == 1){
80101a14:	83 c4 10             	add    $0x10,%esp
80101a17:	83 ff 01             	cmp    $0x1,%edi
80101a1a:	75 aa                	jne    801019c6 <iput+0x26>
80101a1c:	89 f7                	mov    %esi,%edi
80101a1e:	89 d9                	mov    %ebx,%ecx
80101a20:	8d b3 8c 00 00 00    	lea    0x8c(%ebx),%esi
80101a26:	83 c3 5c             	add    $0x5c,%ebx
80101a29:	eb 0c                	jmp    80101a37 <iput+0x97>
80101a2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a30:	83 c3 04             	add    $0x4,%ebx
80101a33:	39 f3                	cmp    %esi,%ebx
80101a35:	74 21                	je     80101a58 <iput+0xb8>
    if(ip->addrs[i]){
80101a37:	8b 13                	mov    (%ebx),%edx
80101a39:	85 d2                	test   %edx,%edx
80101a3b:	74 f3                	je     80101a30 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a3d:	8b 01                	mov    (%ecx),%eax
80101a3f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101a42:	e8 59 fa ff ff       	call   801014a0 <bfree>
      ip->addrs[i] = 0;
80101a47:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80101a4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101a50:	eb de                	jmp    80101a30 <iput+0x90>
80101a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101a58:	8b 81 8c 00 00 00    	mov    0x8c(%ecx),%eax
80101a5e:	89 fe                	mov    %edi,%esi
80101a60:	89 cb                	mov    %ecx,%ebx
80101a62:	85 c0                	test   %eax,%eax
80101a64:	75 2d                	jne    80101a93 <iput+0xf3>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a66:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a69:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101a70:	53                   	push   %ebx
80101a71:	e8 3a fd ff ff       	call   801017b0 <iupdate>
      ip->type = 0;
80101a76:	31 c0                	xor    %eax,%eax
80101a78:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101a7c:	89 1c 24             	mov    %ebx,(%esp)
80101a7f:	e8 2c fd ff ff       	call   801017b0 <iupdate>
      ip->valid = 0;
80101a84:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a8b:	83 c4 10             	add    $0x10,%esp
80101a8e:	e9 33 ff ff ff       	jmp    801019c6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a93:	83 ec 08             	sub    $0x8,%esp
80101a96:	50                   	push   %eax
80101a97:	ff 31                	push   (%ecx)
80101a99:	e8 32 e6 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101a9e:	83 c4 10             	add    $0x10,%esp
80101aa1:	89 d9                	mov    %ebx,%ecx
80101aa3:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa6:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101aa9:	8d 70 5c             	lea    0x5c(%eax),%esi
80101aac:	8d 98 5c 02 00 00    	lea    0x25c(%eax),%ebx
80101ab2:	eb 13                	jmp    80101ac7 <iput+0x127>
80101ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ab8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101abf:	00 
80101ac0:	83 c6 04             	add    $0x4,%esi
80101ac3:	39 de                	cmp    %ebx,%esi
80101ac5:	74 15                	je     80101adc <iput+0x13c>
      if(a[j])
80101ac7:	8b 16                	mov    (%esi),%edx
80101ac9:	85 d2                	test   %edx,%edx
80101acb:	74 f3                	je     80101ac0 <iput+0x120>
        bfree(ip->dev, a[j]);
80101acd:	8b 01                	mov    (%ecx),%eax
80101acf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101ad2:	e8 c9 f9 ff ff       	call   801014a0 <bfree>
80101ad7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ada:	eb e4                	jmp    80101ac0 <iput+0x120>
    brelse(bp);
80101adc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101adf:	83 ec 0c             	sub    $0xc,%esp
80101ae2:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101ae5:	89 cb                	mov    %ecx,%ebx
80101ae7:	50                   	push   %eax
80101ae8:	e8 13 e7 ff ff       	call   80100200 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101aed:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101af3:	8b 03                	mov    (%ebx),%eax
80101af5:	e8 a6 f9 ff ff       	call   801014a0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101afa:	83 c4 10             	add    $0x10,%esp
80101afd:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101b04:	00 00 00 
80101b07:	e9 5a ff ff ff       	jmp    80101a66 <iput+0xc6>
80101b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b10 <iunlockput>:
{
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	56                   	push   %esi
80101b14:	53                   	push   %ebx
80101b15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b18:	85 db                	test   %ebx,%ebx
80101b1a:	74 34                	je     80101b50 <iunlockput+0x40>
80101b1c:	83 ec 0c             	sub    $0xc,%esp
80101b1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b22:	56                   	push   %esi
80101b23:	e8 48 2c 00 00       	call   80104770 <holdingsleep>
80101b28:	83 c4 10             	add    $0x10,%esp
80101b2b:	85 c0                	test   %eax,%eax
80101b2d:	74 21                	je     80101b50 <iunlockput+0x40>
80101b2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b32:	85 c0                	test   %eax,%eax
80101b34:	7e 1a                	jle    80101b50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101b36:	83 ec 0c             	sub    $0xc,%esp
80101b39:	56                   	push   %esi
80101b3a:	e8 f1 2b 00 00       	call   80104730 <releasesleep>
  iput(ip);
80101b3f:	83 c4 10             	add    $0x10,%esp
80101b42:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101b45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b48:	5b                   	pop    %ebx
80101b49:	5e                   	pop    %esi
80101b4a:	5d                   	pop    %ebp
  iput(ip);
80101b4b:	e9 50 fe ff ff       	jmp    801019a0 <iput>
    panic("iunlock");
80101b50:	83 ec 0c             	sub    $0xc,%esp
80101b53:	68 0e 78 10 80       	push   $0x8010780e
80101b58:	e8 43 e8 ff ff       	call   801003a0 <panic>
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi

80101b60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b60:	55                   	push   %ebp
80101b61:	89 e5                	mov    %esp,%ebp
80101b63:	8b 55 08             	mov    0x8(%ebp),%edx
80101b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b69:	8b 0a                	mov    (%edx),%ecx
80101b6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b83:	8b 52 58             	mov    0x58(%edx),%edx
80101b86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b89:	5d                   	pop    %ebp
80101b8a:	c3                   	ret
80101b8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101b90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b9c:	8b 75 08             	mov    0x8(%ebp),%esi
80101b9f:	8b 7d 10             	mov    0x10(%ebp),%edi
80101ba2:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101ba5:	8b 45 14             	mov    0x14(%ebp),%eax
80101ba8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bab:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
80101bb0:	0f 84 aa 00 00 00    	je     80101c60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101bb6:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101bb9:	8b 56 58             	mov    0x58(%esi),%edx
80101bbc:	39 fa                	cmp    %edi,%edx
80101bbe:	0f 82 bd 00 00 00    	jb     80101c81 <readi+0xf1>
80101bc4:	89 f9                	mov    %edi,%ecx
80101bc6:	31 db                	xor    %ebx,%ebx
80101bc8:	01 c1                	add    %eax,%ecx
80101bca:	0f 92 c3             	setb   %bl
80101bcd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101bd0:	0f 82 ab 00 00 00    	jb     80101c81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101bd6:	89 d3                	mov    %edx,%ebx
80101bd8:	29 fb                	sub    %edi,%ebx
80101bda:	39 ca                	cmp    %ecx,%edx
80101bdc:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bdf:	85 c0                	test   %eax,%eax
80101be1:	74 73                	je     80101c56 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101be3:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101be6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101bf3:	89 fa                	mov    %edi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 d8                	mov    %ebx,%eax
80101bfa:	e8 21 f9 ff ff       	call   80101520 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 33                	push   (%ebx)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101c0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c14:	89 f8                	mov    %edi,%eax
80101c16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1b:	29 f3                	sub    %esi,%ebx
80101c1d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101c1f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c23:	39 d9                	cmp    %ebx,%ecx
80101c25:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c28:	83 c4 0c             	add    $0xc,%esp
80101c2b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c2c:	01 de                	add    %ebx,%esi
80101c2e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101c30:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101c33:	50                   	push   %eax
80101c34:	ff 75 e0             	push   -0x20(%ebp)
80101c37:	e8 54 2f 00 00       	call   80104b90 <memmove>
    brelse(bp);
80101c3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c3f:	89 14 24             	mov    %edx,(%esp)
80101c42:	e8 b9 e5 ff ff       	call   80100200 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c4a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101c4d:	83 c4 10             	add    $0x10,%esp
80101c50:	39 de                	cmp    %ebx,%esi
80101c52:	72 9c                	jb     80101bf0 <readi+0x60>
80101c54:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101c56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c59:	5b                   	pop    %ebx
80101c5a:	5e                   	pop    %esi
80101c5b:	5f                   	pop    %edi
80101c5c:	5d                   	pop    %ebp
80101c5d:	c3                   	ret
80101c5e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c60:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101c64:	66 83 fa 09          	cmp    $0x9,%dx
80101c68:	77 17                	ja     80101c81 <readi+0xf1>
80101c6a:	8b 14 d5 00 09 11 80 	mov    -0x7feef700(,%edx,8),%edx
80101c71:	85 d2                	test   %edx,%edx
80101c73:	74 0c                	je     80101c81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101c75:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101c78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c7b:	5b                   	pop    %ebx
80101c7c:	5e                   	pop    %esi
80101c7d:	5f                   	pop    %edi
80101c7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c7f:	ff e2                	jmp    *%edx
      return -1;
80101c81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c86:	eb ce                	jmp    80101c56 <readi+0xc6>
80101c88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101c8f:	00 

80101c90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	57                   	push   %edi
80101c94:	56                   	push   %esi
80101c95:	53                   	push   %ebx
80101c96:	83 ec 1c             	sub    $0x1c,%esp
80101c99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101c9c:	8b 75 14             	mov    0x14(%ebp),%esi
80101c9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca2:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101ca5:	8b 7d 10             	mov    0x10(%ebp),%edi
80101ca8:	89 75 e0             	mov    %esi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cab:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101cb0:	0f 84 ba 00 00 00    	je     80101d70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101cb6:	39 78 58             	cmp    %edi,0x58(%eax)
80101cb9:	0f 82 ea 00 00 00    	jb     80101da9 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101cbf:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101cc2:	89 f2                	mov    %esi,%edx
80101cc4:	01 fa                	add    %edi,%edx
80101cc6:	0f 82 dd 00 00 00    	jb     80101da9 <writei+0x119>
80101ccc:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101cd2:	0f 87 d1 00 00 00    	ja     80101da9 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cd8:	85 f6                	test   %esi,%esi
80101cda:	0f 84 81 00 00 00    	je     80101d61 <writei+0xd1>
80101ce0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101ce7:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cf0:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101cf3:	89 fa                	mov    %edi,%edx
80101cf5:	c1 ea 09             	shr    $0x9,%edx
80101cf8:	89 f0                	mov    %esi,%eax
80101cfa:	e8 21 f8 ff ff       	call   80101520 <bmap>
80101cff:	83 ec 08             	sub    $0x8,%esp
80101d02:	50                   	push   %eax
80101d03:	ff 36                	push   (%esi)
80101d05:	e8 c6 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d15:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d17:	89 f8                	mov    %edi,%eax
80101d19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101d20:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d24:	39 d9                	cmp    %ebx,%ecx
80101d26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d29:	83 c4 0c             	add    $0xc,%esp
80101d2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d2d:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101d2f:	ff 75 dc             	push   -0x24(%ebp)
80101d32:	50                   	push   %eax
80101d33:	e8 58 2e 00 00       	call   80104b90 <memmove>
    log_write(bp);
80101d38:	89 34 24             	mov    %esi,(%esp)
80101d3b:	e8 80 13 00 00       	call   801030c0 <log_write>
    brelse(bp);
80101d40:	89 34 24             	mov    %esi,(%esp)
80101d43:	e8 b8 e4 ff ff       	call   80100200 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d4b:	83 c4 10             	add    $0x10,%esp
80101d4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d54:	3b 45 e0             	cmp    -0x20(%ebp),%eax
80101d57:	72 97                	jb     80101cf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101d59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d5c:	39 78 58             	cmp    %edi,0x58(%eax)
80101d5f:	72 37                	jb     80101d98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d67:	5b                   	pop    %ebx
80101d68:	5e                   	pop    %esi
80101d69:	5f                   	pop    %edi
80101d6a:	5d                   	pop    %ebp
80101d6b:	c3                   	ret
80101d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d74:	66 83 f8 09          	cmp    $0x9,%ax
80101d78:	77 2f                	ja     80101da9 <writei+0x119>
80101d7a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101d81:	85 c0                	test   %eax,%eax
80101d83:	74 24                	je     80101da9 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101d85:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101d88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d8b:	5b                   	pop    %ebx
80101d8c:	5e                   	pop    %esi
80101d8d:	5f                   	pop    %edi
80101d8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d8f:	ff e0                	jmp    *%eax
80101d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101d98:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d9b:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101d9e:	50                   	push   %eax
80101d9f:	e8 0c fa ff ff       	call   801017b0 <iupdate>
80101da4:	83 c4 10             	add    $0x10,%esp
80101da7:	eb b8                	jmp    80101d61 <writei+0xd1>
      return -1;
80101da9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dae:	eb b4                	jmp    80101d64 <writei+0xd4>

80101db0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101db0:	55                   	push   %ebp
80101db1:	89 e5                	mov    %esp,%ebp
80101db3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101db6:	6a 0e                	push   $0xe
80101db8:	ff 75 0c             	push   0xc(%ebp)
80101dbb:	ff 75 08             	push   0x8(%ebp)
80101dbe:	e8 3d 2e 00 00       	call   80104c00 <strncmp>
}
80101dc3:	c9                   	leave
80101dc4:	c3                   	ret
80101dc5:	8d 76 00             	lea    0x0(%esi),%esi
80101dc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101dcf:	00 

80101dd0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101dd0:	55                   	push   %ebp
80101dd1:	89 e5                	mov    %esp,%ebp
80101dd3:	57                   	push   %edi
80101dd4:	56                   	push   %esi
80101dd5:	53                   	push   %ebx
80101dd6:	83 ec 1c             	sub    $0x1c,%esp
80101dd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101ddc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101de1:	0f 85 8d 00 00 00    	jne    80101e74 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101de7:	8b 53 58             	mov    0x58(%ebx),%edx
80101dea:	31 ff                	xor    %edi,%edi
80101dec:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101def:	85 d2                	test   %edx,%edx
80101df1:	74 46                	je     80101e39 <dirlookup+0x69>
80101df3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80101df8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101dff:	00 
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e00:	6a 10                	push   $0x10
80101e02:	57                   	push   %edi
80101e03:	56                   	push   %esi
80101e04:	53                   	push   %ebx
80101e05:	e8 86 fd ff ff       	call   80101b90 <readi>
80101e0a:	83 c4 10             	add    $0x10,%esp
80101e0d:	83 f8 10             	cmp    $0x10,%eax
80101e10:	75 55                	jne    80101e67 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101e12:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e17:	74 18                	je     80101e31 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101e19:	83 ec 04             	sub    $0x4,%esp
80101e1c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e1f:	6a 0e                	push   $0xe
80101e21:	50                   	push   %eax
80101e22:	ff 75 0c             	push   0xc(%ebp)
80101e25:	e8 d6 2d 00 00       	call   80104c00 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e2a:	83 c4 10             	add    $0x10,%esp
80101e2d:	85 c0                	test   %eax,%eax
80101e2f:	74 17                	je     80101e48 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e31:	83 c7 10             	add    $0x10,%edi
80101e34:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e37:	72 c7                	jb     80101e00 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101e3c:	31 c0                	xor    %eax,%eax
}
80101e3e:	5b                   	pop    %ebx
80101e3f:	5e                   	pop    %esi
80101e40:	5f                   	pop    %edi
80101e41:	5d                   	pop    %ebp
80101e42:	c3                   	ret
80101e43:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101e48:	8b 45 10             	mov    0x10(%ebp),%eax
80101e4b:	85 c0                	test   %eax,%eax
80101e4d:	74 05                	je     80101e54 <dirlookup+0x84>
        *poff = off;
80101e4f:	8b 45 10             	mov    0x10(%ebp),%eax
80101e52:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e54:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e58:	8b 03                	mov    (%ebx),%eax
80101e5a:	e8 01 f5 ff ff       	call   80101360 <iget>
}
80101e5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e62:	5b                   	pop    %ebx
80101e63:	5e                   	pop    %esi
80101e64:	5f                   	pop    %edi
80101e65:	5d                   	pop    %ebp
80101e66:	c3                   	ret
      panic("dirlookup read");
80101e67:	83 ec 0c             	sub    $0xc,%esp
80101e6a:	68 28 78 10 80       	push   $0x80107828
80101e6f:	e8 2c e5 ff ff       	call   801003a0 <panic>
    panic("dirlookup not DIR");
80101e74:	83 ec 0c             	sub    $0xc,%esp
80101e77:	68 16 78 10 80       	push   $0x80107816
80101e7c:	e8 1f e5 ff ff       	call   801003a0 <panic>
80101e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101e8f:	00 

80101e90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e90:	55                   	push   %ebp
80101e91:	89 e5                	mov    %esp,%ebp
80101e93:	57                   	push   %edi
80101e94:	56                   	push   %esi
80101e95:	53                   	push   %ebx
80101e96:	89 c3                	mov    %eax,%ebx
80101e98:	83 ec 1c             	sub    $0x1c,%esp
80101e9b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e9e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101ea1:	80 38 2f             	cmpb   $0x2f,(%eax)
80101ea4:	0f 84 bc 01 00 00    	je     80102066 <namex+0x1d6>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101eaa:	e8 f1 1c 00 00       	call   80103ba0 <myproc>
  acquire(&icache.lock);
80101eaf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101eb2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101eb5:	68 60 09 11 80       	push   $0x80110960
80101eba:	e8 21 2b 00 00       	call   801049e0 <acquire>
  ip->ref++;
80101ebf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ec3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101eca:	e8 b1 2a 00 00       	call   80104980 <release>
80101ecf:	83 c4 10             	add    $0x10,%esp
80101ed2:	eb 0f                	jmp    80101ee3 <namex+0x53>
80101ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ed8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101edf:	00 
    path++;
80101ee0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ee3:	0f b6 03             	movzbl (%ebx),%eax
80101ee6:	3c 2f                	cmp    $0x2f,%al
80101ee8:	74 f6                	je     80101ee0 <namex+0x50>
  if(*path == 0)
80101eea:	84 c0                	test   %al,%al
80101eec:	0f 84 16 01 00 00    	je     80102008 <namex+0x178>
  while(*path != '/' && *path != 0)
80101ef2:	0f b6 03             	movzbl (%ebx),%eax
80101ef5:	84 c0                	test   %al,%al
80101ef7:	0f 84 23 01 00 00    	je     80102020 <namex+0x190>
80101efd:	89 df                	mov    %ebx,%edi
80101eff:	3c 2f                	cmp    $0x2f,%al
80101f01:	0f 84 19 01 00 00    	je     80102020 <namex+0x190>
80101f07:	90                   	nop
80101f08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101f0f:	00 
80101f10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101f14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101f17:	3c 2f                	cmp    $0x2f,%al
80101f19:	74 04                	je     80101f1f <namex+0x8f>
80101f1b:	84 c0                	test   %al,%al
80101f1d:	75 f1                	jne    80101f10 <namex+0x80>
  len = path - s;
80101f1f:	89 f8                	mov    %edi,%eax
80101f21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101f23:	83 f8 0d             	cmp    $0xd,%eax
80101f26:	0f 8e b4 00 00 00    	jle    80101fe0 <namex+0x150>
    memmove(name, s, DIRSIZ);
80101f2c:	83 ec 04             	sub    $0x4,%esp
80101f2f:	6a 0e                	push   $0xe
80101f31:	53                   	push   %ebx
80101f32:	89 fb                	mov    %edi,%ebx
80101f34:	ff 75 e4             	push   -0x1c(%ebp)
80101f37:	e8 54 2c 00 00       	call   80104b90 <memmove>
80101f3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101f42:	75 14                	jne    80101f58 <namex+0xc8>
80101f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101f4f:	00 
    path++;
80101f50:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f53:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f56:	74 f8                	je     80101f50 <namex+0xc0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f58:	83 ec 0c             	sub    $0xc,%esp
80101f5b:	56                   	push   %esi
80101f5c:	e8 0f f9 ff ff       	call   80101870 <ilock>
    if(ip->type != T_DIR){
80101f61:	83 c4 10             	add    $0x10,%esp
80101f64:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f69:	0f 85 bd 00 00 00    	jne    8010202c <namex+0x19c>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f72:	85 c0                	test   %eax,%eax
80101f74:	74 09                	je     80101f7f <namex+0xef>
80101f76:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f79:	0f 84 fd 00 00 00    	je     8010207c <namex+0x1ec>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f7f:	83 ec 04             	sub    $0x4,%esp
80101f82:	6a 00                	push   $0x0
80101f84:	ff 75 e4             	push   -0x1c(%ebp)
80101f87:	56                   	push   %esi
80101f88:	e8 43 fe ff ff       	call   80101dd0 <dirlookup>
80101f8d:	83 c4 10             	add    $0x10,%esp
80101f90:	89 c7                	mov    %eax,%edi
80101f92:	85 c0                	test   %eax,%eax
80101f94:	0f 84 92 00 00 00    	je     8010202c <namex+0x19c>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f9a:	83 ec 0c             	sub    $0xc,%esp
80101f9d:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101fa0:	51                   	push   %ecx
80101fa1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101fa4:	e8 c7 27 00 00       	call   80104770 <holdingsleep>
80101fa9:	83 c4 10             	add    $0x10,%esp
80101fac:	85 c0                	test   %eax,%eax
80101fae:	0f 84 08 01 00 00    	je     801020bc <namex+0x22c>
80101fb4:	8b 56 08             	mov    0x8(%esi),%edx
80101fb7:	85 d2                	test   %edx,%edx
80101fb9:	0f 8e fd 00 00 00    	jle    801020bc <namex+0x22c>
  releasesleep(&ip->lock);
80101fbf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101fc2:	83 ec 0c             	sub    $0xc,%esp
80101fc5:	51                   	push   %ecx
80101fc6:	e8 65 27 00 00       	call   80104730 <releasesleep>
  iput(ip);
80101fcb:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101fce:	89 fe                	mov    %edi,%esi
  iput(ip);
80101fd0:	e8 cb f9 ff ff       	call   801019a0 <iput>
80101fd5:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101fd8:	e9 06 ff ff ff       	jmp    80101ee3 <namex+0x53>
80101fdd:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101fe0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101fe3:	01 c2                	add    %eax,%edx
80101fe5:	89 55 e0             	mov    %edx,-0x20(%ebp)
    memmove(name, s, len);
80101fe8:	83 ec 04             	sub    $0x4,%esp
80101feb:	50                   	push   %eax
80101fec:	53                   	push   %ebx
    name[len] = 0;
80101fed:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101fef:	ff 75 e4             	push   -0x1c(%ebp)
80101ff2:	e8 99 2b 00 00       	call   80104b90 <memmove>
    name[len] = 0;
80101ff7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ffa:	83 c4 10             	add    $0x10,%esp
80101ffd:	c6 00 00             	movb   $0x0,(%eax)
80102000:	e9 3a ff ff ff       	jmp    80101f3f <namex+0xaf>
80102005:	8d 76 00             	lea    0x0(%esi),%esi
  }
  if(nameiparent){
80102008:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010200b:	85 c0                	test   %eax,%eax
8010200d:	0f 85 99 00 00 00    	jne    801020ac <namex+0x21c>
    iput(ip);
    return 0;
  }
  return ip;
}
80102013:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102016:	89 f0                	mov    %esi,%eax
80102018:	5b                   	pop    %ebx
80102019:	5e                   	pop    %esi
8010201a:	5f                   	pop    %edi
8010201b:	5d                   	pop    %ebp
8010201c:	c3                   	ret
8010201d:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80102020:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102023:	89 df                	mov    %ebx,%edi
80102025:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102028:	31 c0                	xor    %eax,%eax
8010202a:	eb bc                	jmp    80101fe8 <namex+0x158>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010202c:	83 ec 0c             	sub    $0xc,%esp
8010202f:	8d 5e 0c             	lea    0xc(%esi),%ebx
80102032:	53                   	push   %ebx
80102033:	e8 38 27 00 00       	call   80104770 <holdingsleep>
80102038:	83 c4 10             	add    $0x10,%esp
8010203b:	85 c0                	test   %eax,%eax
8010203d:	74 7d                	je     801020bc <namex+0x22c>
8010203f:	8b 4e 08             	mov    0x8(%esi),%ecx
80102042:	85 c9                	test   %ecx,%ecx
80102044:	7e 76                	jle    801020bc <namex+0x22c>
  releasesleep(&ip->lock);
80102046:	83 ec 0c             	sub    $0xc,%esp
80102049:	53                   	push   %ebx
8010204a:	e8 e1 26 00 00       	call   80104730 <releasesleep>
  iput(ip);
8010204f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102052:	31 f6                	xor    %esi,%esi
  iput(ip);
80102054:	e8 47 f9 ff ff       	call   801019a0 <iput>
      return 0;
80102059:	83 c4 10             	add    $0x10,%esp
}
8010205c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010205f:	89 f0                	mov    %esi,%eax
80102061:	5b                   	pop    %ebx
80102062:	5e                   	pop    %esi
80102063:	5f                   	pop    %edi
80102064:	5d                   	pop    %ebp
80102065:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80102066:	ba 01 00 00 00       	mov    $0x1,%edx
8010206b:	b8 01 00 00 00       	mov    $0x1,%eax
80102070:	e8 eb f2 ff ff       	call   80101360 <iget>
80102075:	89 c6                	mov    %eax,%esi
80102077:	e9 67 fe ff ff       	jmp    80101ee3 <namex+0x53>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010207c:	83 ec 0c             	sub    $0xc,%esp
8010207f:	8d 5e 0c             	lea    0xc(%esi),%ebx
80102082:	53                   	push   %ebx
80102083:	e8 e8 26 00 00       	call   80104770 <holdingsleep>
80102088:	83 c4 10             	add    $0x10,%esp
8010208b:	85 c0                	test   %eax,%eax
8010208d:	74 2d                	je     801020bc <namex+0x22c>
8010208f:	8b 7e 08             	mov    0x8(%esi),%edi
80102092:	85 ff                	test   %edi,%edi
80102094:	7e 26                	jle    801020bc <namex+0x22c>
  releasesleep(&ip->lock);
80102096:	83 ec 0c             	sub    $0xc,%esp
80102099:	53                   	push   %ebx
8010209a:	e8 91 26 00 00       	call   80104730 <releasesleep>
}
8010209f:	83 c4 10             	add    $0x10,%esp
}
801020a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020a5:	89 f0                	mov    %esi,%eax
801020a7:	5b                   	pop    %ebx
801020a8:	5e                   	pop    %esi
801020a9:	5f                   	pop    %edi
801020aa:	5d                   	pop    %ebp
801020ab:	c3                   	ret
    iput(ip);
801020ac:	83 ec 0c             	sub    $0xc,%esp
801020af:	56                   	push   %esi
      return 0;
801020b0:	31 f6                	xor    %esi,%esi
    iput(ip);
801020b2:	e8 e9 f8 ff ff       	call   801019a0 <iput>
    return 0;
801020b7:	83 c4 10             	add    $0x10,%esp
801020ba:	eb a0                	jmp    8010205c <namex+0x1cc>
    panic("iunlock");
801020bc:	83 ec 0c             	sub    $0xc,%esp
801020bf:	68 0e 78 10 80       	push   $0x8010780e
801020c4:	e8 d7 e2 ff ff       	call   801003a0 <panic>
801020c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020d0 <dirlink>:
{
801020d0:	55                   	push   %ebp
801020d1:	89 e5                	mov    %esp,%ebp
801020d3:	57                   	push   %edi
801020d4:	56                   	push   %esi
801020d5:	53                   	push   %ebx
801020d6:	83 ec 20             	sub    $0x20,%esp
801020d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801020dc:	6a 00                	push   $0x0
801020de:	ff 75 0c             	push   0xc(%ebp)
801020e1:	53                   	push   %ebx
801020e2:	e8 e9 fc ff ff       	call   80101dd0 <dirlookup>
801020e7:	83 c4 10             	add    $0x10,%esp
801020ea:	85 c0                	test   %eax,%eax
801020ec:	75 67                	jne    80102155 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801020ee:	8b 7b 58             	mov    0x58(%ebx),%edi
801020f1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020f4:	85 ff                	test   %edi,%edi
801020f6:	74 29                	je     80102121 <dirlink+0x51>
801020f8:	31 ff                	xor    %edi,%edi
801020fa:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020fd:	eb 09                	jmp    80102108 <dirlink+0x38>
801020ff:	90                   	nop
80102100:	83 c7 10             	add    $0x10,%edi
80102103:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102106:	73 19                	jae    80102121 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102108:	6a 10                	push   $0x10
8010210a:	57                   	push   %edi
8010210b:	56                   	push   %esi
8010210c:	53                   	push   %ebx
8010210d:	e8 7e fa ff ff       	call   80101b90 <readi>
80102112:	83 c4 10             	add    $0x10,%esp
80102115:	83 f8 10             	cmp    $0x10,%eax
80102118:	75 4e                	jne    80102168 <dirlink+0x98>
    if(de.inum == 0)
8010211a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010211f:	75 df                	jne    80102100 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102121:	83 ec 04             	sub    $0x4,%esp
80102124:	8d 45 da             	lea    -0x26(%ebp),%eax
80102127:	6a 0e                	push   $0xe
80102129:	ff 75 0c             	push   0xc(%ebp)
8010212c:	50                   	push   %eax
8010212d:	e8 1e 2b 00 00       	call   80104c50 <strncpy>
  de.inum = inum;
80102132:	8b 45 10             	mov    0x10(%ebp),%eax
80102135:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102139:	6a 10                	push   $0x10
8010213b:	57                   	push   %edi
8010213c:	56                   	push   %esi
8010213d:	53                   	push   %ebx
8010213e:	e8 4d fb ff ff       	call   80101c90 <writei>
80102143:	83 c4 20             	add    $0x20,%esp
80102146:	83 f8 10             	cmp    $0x10,%eax
80102149:	75 2a                	jne    80102175 <dirlink+0xa5>
  return 0;
8010214b:	31 c0                	xor    %eax,%eax
}
8010214d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102150:	5b                   	pop    %ebx
80102151:	5e                   	pop    %esi
80102152:	5f                   	pop    %edi
80102153:	5d                   	pop    %ebp
80102154:	c3                   	ret
    iput(ip);
80102155:	83 ec 0c             	sub    $0xc,%esp
80102158:	50                   	push   %eax
80102159:	e8 42 f8 ff ff       	call   801019a0 <iput>
    return -1;
8010215e:	83 c4 10             	add    $0x10,%esp
80102161:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102166:	eb e5                	jmp    8010214d <dirlink+0x7d>
      panic("dirlink read");
80102168:	83 ec 0c             	sub    $0xc,%esp
8010216b:	68 37 78 10 80       	push   $0x80107837
80102170:	e8 2b e2 ff ff       	call   801003a0 <panic>
    panic("dirlink");
80102175:	83 ec 0c             	sub    $0xc,%esp
80102178:	68 93 7a 10 80       	push   $0x80107a93
8010217d:	e8 1e e2 ff ff       	call   801003a0 <panic>
80102182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102188:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010218f:	00 

80102190 <namei>:

struct inode*
namei(char *path)
{
80102190:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102191:	31 d2                	xor    %edx,%edx
{
80102193:	89 e5                	mov    %esp,%ebp
80102195:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102198:	8b 45 08             	mov    0x8(%ebp),%eax
8010219b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010219e:	e8 ed fc ff ff       	call   80101e90 <namex>
}
801021a3:	c9                   	leave
801021a4:	c3                   	ret
801021a5:	8d 76 00             	lea    0x0(%esi),%esi
801021a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021af:	00 

801021b0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801021b0:	55                   	push   %ebp
  return namex(path, 1, name);
801021b1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801021b6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801021b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801021bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801021be:	5d                   	pop    %ebp
  return namex(path, 1, name);
801021bf:	e9 cc fc ff ff       	jmp    80101e90 <namex>
801021c4:	66 90                	xchg   %ax,%ax
801021c6:	66 90                	xchg   %ax,%ax
801021c8:	66 90                	xchg   %ax,%ax
801021ca:	66 90                	xchg   %ax,%ax
801021cc:	66 90                	xchg   %ax,%ax
801021ce:	66 90                	xchg   %ax,%ax

801021d0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	57                   	push   %edi
801021d4:	56                   	push   %esi
801021d5:	53                   	push   %ebx
801021d6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801021d9:	85 c0                	test   %eax,%eax
801021db:	0f 84 ac 00 00 00    	je     8010228d <idestart+0xbd>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801021e1:	8b 70 08             	mov    0x8(%eax),%esi
801021e4:	89 c3                	mov    %eax,%ebx
801021e6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801021ec:	0f 87 8e 00 00 00    	ja     80102280 <idestart+0xb0>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021f2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021f7:	90                   	nop
801021f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021ff:	00 
80102200:	89 ca                	mov    %ecx,%edx
80102202:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102203:	83 e0 c0             	and    $0xffffffc0,%eax
80102206:	3c 40                	cmp    $0x40,%al
80102208:	75 f6                	jne    80102200 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010220a:	ba f6 03 00 00       	mov    $0x3f6,%edx
8010220f:	31 c0                	xor    %eax,%eax
80102211:	ee                   	out    %al,(%dx)
80102212:	b8 01 00 00 00       	mov    $0x1,%eax
80102217:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010221c:	ee                   	out    %al,(%dx)
8010221d:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102222:	89 f0                	mov    %esi,%eax
80102224:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102225:	89 f0                	mov    %esi,%eax
80102227:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010222c:	c1 f8 08             	sar    $0x8,%eax
8010222f:	ee                   	out    %al,(%dx)
80102230:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102235:	31 c0                	xor    %eax,%eax
80102237:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102238:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010223c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102241:	c1 e0 04             	shl    $0x4,%eax
80102244:	83 e0 10             	and    $0x10,%eax
80102247:	83 c8 e0             	or     $0xffffffe0,%eax
8010224a:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010224b:	f6 03 04             	testb  $0x4,(%ebx)
8010224e:	75 10                	jne    80102260 <idestart+0x90>
80102250:	b8 20 00 00 00       	mov    $0x20,%eax
80102255:	89 ca                	mov    %ecx,%edx
80102257:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102258:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010225b:	5b                   	pop    %ebx
8010225c:	5e                   	pop    %esi
8010225d:	5f                   	pop    %edi
8010225e:	5d                   	pop    %ebp
8010225f:	c3                   	ret
80102260:	b8 30 00 00 00       	mov    $0x30,%eax
80102265:	89 ca                	mov    %ecx,%edx
80102267:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102268:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
8010226d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102270:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102275:	fc                   	cld
80102276:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102278:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010227b:	5b                   	pop    %ebx
8010227c:	5e                   	pop    %esi
8010227d:	5f                   	pop    %edi
8010227e:	5d                   	pop    %ebp
8010227f:	c3                   	ret
    panic("incorrect blockno");
80102280:	83 ec 0c             	sub    $0xc,%esp
80102283:	68 4d 78 10 80       	push   $0x8010784d
80102288:	e8 13 e1 ff ff       	call   801003a0 <panic>
    panic("idestart");
8010228d:	83 ec 0c             	sub    $0xc,%esp
80102290:	68 44 78 10 80       	push   $0x80107844
80102295:	e8 06 e1 ff ff       	call   801003a0 <panic>
8010229a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801022a0 <ideinit>:
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801022a6:	68 5f 78 10 80       	push   $0x8010785f
801022ab:	68 00 26 11 80       	push   $0x80112600
801022b0:	e8 0b 25 00 00       	call   801047c0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801022b5:	58                   	pop    %eax
801022b6:	a1 84 27 11 80       	mov    0x80112784,%eax
801022bb:	5a                   	pop    %edx
801022bc:	83 e8 01             	sub    $0x1,%eax
801022bf:	50                   	push   %eax
801022c0:	6a 0e                	push   $0xe
801022c2:	e8 b9 02 00 00       	call   80102580 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022c7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022ca:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022cf:	90                   	nop
801022d0:	ec                   	in     (%dx),%al
801022d1:	83 e0 c0             	and    $0xffffffc0,%eax
801022d4:	3c 40                	cmp    $0x40,%al
801022d6:	75 f8                	jne    801022d0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022d8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801022dd:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022e2:	ee                   	out    %al,(%dx)
801022e3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022e8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022ed:	eb 06                	jmp    801022f5 <ideinit+0x55>
801022ef:	90                   	nop
  for(i=0; i<1000; i++){
801022f0:	83 e9 01             	sub    $0x1,%ecx
801022f3:	74 0f                	je     80102304 <ideinit+0x64>
801022f5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801022f6:	84 c0                	test   %al,%al
801022f8:	74 f6                	je     801022f0 <ideinit+0x50>
      havedisk1 = 1;
801022fa:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102301:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102304:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102309:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010230e:	ee                   	out    %al,(%dx)
}
8010230f:	c9                   	leave
80102310:	c3                   	ret
80102311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102318:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010231f:	00 

80102320 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	57                   	push   %edi
80102324:	56                   	push   %esi
80102325:	53                   	push   %ebx
80102326:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102329:	68 00 26 11 80       	push   $0x80112600
8010232e:	e8 ad 26 00 00       	call   801049e0 <acquire>

  if((b = idequeue) == 0){
80102333:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 db                	test   %ebx,%ebx
8010233e:	74 63                	je     801023a3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102340:	8b 43 58             	mov    0x58(%ebx),%eax
80102343:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102348:	8b 33                	mov    (%ebx),%esi
8010234a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102350:	75 2f                	jne    80102381 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102352:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102357:	90                   	nop
80102358:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010235f:	00 
80102360:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102361:	89 c1                	mov    %eax,%ecx
80102363:	83 e1 c0             	and    $0xffffffc0,%ecx
80102366:	80 f9 40             	cmp    $0x40,%cl
80102369:	75 f5                	jne    80102360 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010236b:	a8 21                	test   $0x21,%al
8010236d:	75 12                	jne    80102381 <ideintr+0x61>
  asm volatile("cld; rep insl" :
8010236f:	b9 80 00 00 00       	mov    $0x80,%ecx
80102374:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102379:	8d 7b 5c             	lea    0x5c(%ebx),%edi
8010237c:	fc                   	cld
8010237d:	f3 6d                	rep insl (%dx),%es:(%edi)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010237f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102381:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102384:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102387:	83 ce 02             	or     $0x2,%esi
8010238a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010238c:	53                   	push   %ebx
8010238d:	e8 4e 21 00 00       	call   801044e0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102392:	a1 e4 25 11 80       	mov    0x801125e4,%eax
80102397:	83 c4 10             	add    $0x10,%esp
8010239a:	85 c0                	test   %eax,%eax
8010239c:	74 05                	je     801023a3 <ideintr+0x83>
    idestart(idequeue);
8010239e:	e8 2d fe ff ff       	call   801021d0 <idestart>
    release(&idelock);
801023a3:	83 ec 0c             	sub    $0xc,%esp
801023a6:	68 00 26 11 80       	push   $0x80112600
801023ab:	e8 d0 25 00 00       	call   80104980 <release>

  release(&idelock);
}
801023b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023b3:	5b                   	pop    %ebx
801023b4:	5e                   	pop    %esi
801023b5:	5f                   	pop    %edi
801023b6:	5d                   	pop    %ebp
801023b7:	c3                   	ret
801023b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801023bf:	00 

801023c0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	53                   	push   %ebx
801023c4:	83 ec 10             	sub    $0x10,%esp
801023c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801023ca:	8d 43 0c             	lea    0xc(%ebx),%eax
801023cd:	50                   	push   %eax
801023ce:	e8 9d 23 00 00       	call   80104770 <holdingsleep>
801023d3:	83 c4 10             	add    $0x10,%esp
801023d6:	85 c0                	test   %eax,%eax
801023d8:	0f 84 c3 00 00 00    	je     801024a1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801023de:	8b 03                	mov    (%ebx),%eax
801023e0:	83 e0 06             	and    $0x6,%eax
801023e3:	83 f8 02             	cmp    $0x2,%eax
801023e6:	0f 84 a8 00 00 00    	je     80102494 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801023ec:	8b 53 04             	mov    0x4(%ebx),%edx
801023ef:	85 d2                	test   %edx,%edx
801023f1:	74 0d                	je     80102400 <iderw+0x40>
801023f3:	a1 e0 25 11 80       	mov    0x801125e0,%eax
801023f8:	85 c0                	test   %eax,%eax
801023fa:	0f 84 87 00 00 00    	je     80102487 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102400:	83 ec 0c             	sub    $0xc,%esp
80102403:	68 00 26 11 80       	push   $0x80112600
80102408:	e8 d3 25 00 00       	call   801049e0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010240d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102412:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102419:	83 c4 10             	add    $0x10,%esp
8010241c:	85 c0                	test   %eax,%eax
8010241e:	74 60                	je     80102480 <iderw+0xc0>
80102420:	89 c2                	mov    %eax,%edx
80102422:	8b 40 58             	mov    0x58(%eax),%eax
80102425:	85 c0                	test   %eax,%eax
80102427:	75 f7                	jne    80102420 <iderw+0x60>
80102429:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010242c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010242e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102434:	74 3a                	je     80102470 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102436:	8b 03                	mov    (%ebx),%eax
80102438:	83 e0 06             	and    $0x6,%eax
8010243b:	83 f8 02             	cmp    $0x2,%eax
8010243e:	74 1b                	je     8010245b <iderw+0x9b>
    sleep(b, &idelock);
80102440:	83 ec 08             	sub    $0x8,%esp
80102443:	68 00 26 11 80       	push   $0x80112600
80102448:	53                   	push   %ebx
80102449:	e8 b2 1f 00 00       	call   80104400 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010244e:	8b 03                	mov    (%ebx),%eax
80102450:	83 c4 10             	add    $0x10,%esp
80102453:	83 e0 06             	and    $0x6,%eax
80102456:	83 f8 02             	cmp    $0x2,%eax
80102459:	75 e5                	jne    80102440 <iderw+0x80>
  }


  release(&idelock);
8010245b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102462:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102465:	c9                   	leave
  release(&idelock);
80102466:	e9 15 25 00 00       	jmp    80104980 <release>
8010246b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80102470:	89 d8                	mov    %ebx,%eax
80102472:	e8 59 fd ff ff       	call   801021d0 <idestart>
80102477:	eb bd                	jmp    80102436 <iderw+0x76>
80102479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102480:	ba e4 25 11 80       	mov    $0x801125e4,%edx
80102485:	eb a5                	jmp    8010242c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102487:	83 ec 0c             	sub    $0xc,%esp
8010248a:	68 8e 78 10 80       	push   $0x8010788e
8010248f:	e8 0c df ff ff       	call   801003a0 <panic>
    panic("iderw: nothing to do");
80102494:	83 ec 0c             	sub    $0xc,%esp
80102497:	68 79 78 10 80       	push   $0x80107879
8010249c:	e8 ff de ff ff       	call   801003a0 <panic>
    panic("iderw: buf not locked");
801024a1:	83 ec 0c             	sub    $0xc,%esp
801024a4:	68 63 78 10 80       	push   $0x80107863
801024a9:	e8 f2 de ff ff       	call   801003a0 <panic>
801024ae:	66 90                	xchg   %ax,%ax
801024b0:	66 90                	xchg   %ax,%ax
801024b2:	66 90                	xchg   %ax,%ax
801024b4:	66 90                	xchg   %ax,%ax
801024b6:	66 90                	xchg   %ax,%ax
801024b8:	66 90                	xchg   %ax,%ax
801024ba:	66 90                	xchg   %ax,%ax
801024bc:	66 90                	xchg   %ax,%ax
801024be:	66 90                	xchg   %ax,%ax

801024c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	56                   	push   %esi
801024c4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801024c5:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801024cc:	00 c0 fe 
  ioapic->reg = reg;
801024cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801024d6:	00 00 00 
  return ioapic->data;
801024d9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801024df:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801024e2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801024e8:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024ee:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801024f5:	c1 ee 10             	shr    $0x10,%esi
801024f8:	89 f0                	mov    %esi,%eax
801024fa:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801024fd:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102500:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102503:	39 c2                	cmp    %eax,%edx
80102505:	74 16                	je     8010251d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102507:	83 ec 0c             	sub    $0xc,%esp
8010250a:	68 48 7c 10 80       	push   $0x80107c48
8010250f:	e8 bc e1 ff ff       	call   801006d0 <cprintf>
  ioapic->reg = reg;
80102514:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010251a:	83 c4 10             	add    $0x10,%esp
{
8010251d:	ba 10 00 00 00       	mov    $0x10,%edx
80102522:	31 c0                	xor    %eax,%eax
80102524:	eb 1a                	jmp    80102540 <ioapicinit+0x80>
80102526:	66 90                	xchg   %ax,%ax
80102528:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010252f:	00 
80102530:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102537:	00 
80102538:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010253f:	00 
  ioapic->reg = reg;
80102540:	89 13                	mov    %edx,(%ebx)
80102542:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
80102545:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010254b:	83 c0 01             	add    $0x1,%eax
8010254e:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
80102554:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
80102557:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
8010255a:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010255d:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
8010255f:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102565:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
8010256c:	39 c6                	cmp    %eax,%esi
8010256e:	7d d0                	jge    80102540 <ioapicinit+0x80>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102570:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102573:	5b                   	pop    %ebx
80102574:	5e                   	pop    %esi
80102575:	5d                   	pop    %ebp
80102576:	c3                   	ret
80102577:	90                   	nop
80102578:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010257f:	00 

80102580 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102580:	55                   	push   %ebp
  ioapic->reg = reg;
80102581:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102587:	89 e5                	mov    %esp,%ebp
80102589:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010258c:	8d 50 20             	lea    0x20(%eax),%edx
8010258f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102593:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102595:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010259b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010259e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801025a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025a6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801025ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801025b1:	5d                   	pop    %ebp
801025b2:	c3                   	ret
801025b3:	66 90                	xchg   %ax,%ax
801025b5:	66 90                	xchg   %ax,%ax
801025b7:	66 90                	xchg   %ax,%ax
801025b9:	66 90                	xchg   %ax,%ax
801025bb:	66 90                	xchg   %ax,%ax
801025bd:	66 90                	xchg   %ax,%ax
801025bf:	90                   	nop

801025c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	53                   	push   %ebx
801025c4:	83 ec 04             	sub    $0x4,%esp
801025c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801025ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801025d0:	75 76                	jne    80102648 <kfree+0x88>
801025d2:	81 fb d0 66 11 80    	cmp    $0x801166d0,%ebx
801025d8:	72 6e                	jb     80102648 <kfree+0x88>
801025da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801025e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801025e5:	77 61                	ja     80102648 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801025e7:	83 ec 04             	sub    $0x4,%esp
801025ea:	68 00 10 00 00       	push   $0x1000
801025ef:	6a 01                	push   $0x1
801025f1:	53                   	push   %ebx
801025f2:	e8 09 25 00 00       	call   80104b00 <memset>

  if(kmem.use_lock)
801025f7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	85 d2                	test   %edx,%edx
80102602:	75 1c                	jne    80102620 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102604:	a1 78 26 11 80       	mov    0x80112678,%eax
80102609:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010260b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102610:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102616:	85 c0                	test   %eax,%eax
80102618:	75 1e                	jne    80102638 <kfree+0x78>
    release(&kmem.lock);
}
8010261a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010261d:	c9                   	leave
8010261e:	c3                   	ret
8010261f:	90                   	nop
    acquire(&kmem.lock);
80102620:	83 ec 0c             	sub    $0xc,%esp
80102623:	68 40 26 11 80       	push   $0x80112640
80102628:	e8 b3 23 00 00       	call   801049e0 <acquire>
8010262d:	83 c4 10             	add    $0x10,%esp
80102630:	eb d2                	jmp    80102604 <kfree+0x44>
80102632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102638:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010263f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102642:	c9                   	leave
    release(&kmem.lock);
80102643:	e9 38 23 00 00       	jmp    80104980 <release>
    panic("kfree");
80102648:	83 ec 0c             	sub    $0xc,%esp
8010264b:	68 ac 78 10 80       	push   $0x801078ac
80102650:	e8 4b dd ff ff       	call   801003a0 <panic>
80102655:	8d 76 00             	lea    0x0(%esi),%esi
80102658:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010265f:	00 

80102660 <freerange>:
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	56                   	push   %esi
80102664:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102665:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102668:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010266b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102671:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102677:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010267d:	39 de                	cmp    %ebx,%esi
8010267f:	72 2b                	jb     801026ac <freerange+0x4c>
80102681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102688:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010268f:	00 
    kfree(p);
80102690:	83 ec 0c             	sub    $0xc,%esp
80102693:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102699:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010269f:	50                   	push   %eax
801026a0:	e8 1b ff ff ff       	call   801025c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026a5:	83 c4 10             	add    $0x10,%esp
801026a8:	39 de                	cmp    %ebx,%esi
801026aa:	73 e4                	jae    80102690 <freerange+0x30>
}
801026ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026af:	5b                   	pop    %ebx
801026b0:	5e                   	pop    %esi
801026b1:	5d                   	pop    %ebp
801026b2:	c3                   	ret
801026b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801026b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026bf:	00 

801026c0 <kinit2>:
{
801026c0:	55                   	push   %ebp
801026c1:	89 e5                	mov    %esp,%ebp
801026c3:	56                   	push   %esi
801026c4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801026c5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801026cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026dd:	39 de                	cmp    %ebx,%esi
801026df:	72 2b                	jb     8010270c <kinit2+0x4c>
801026e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026ef:	00 
    kfree(p);
801026f0:	83 ec 0c             	sub    $0xc,%esp
801026f3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026ff:	50                   	push   %eax
80102700:	e8 bb fe ff ff       	call   801025c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102705:	83 c4 10             	add    $0x10,%esp
80102708:	39 de                	cmp    %ebx,%esi
8010270a:	73 e4                	jae    801026f0 <kinit2+0x30>
  kmem.use_lock = 1;
8010270c:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102713:	00 00 00 
}
80102716:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102719:	5b                   	pop    %ebx
8010271a:	5e                   	pop    %esi
8010271b:	5d                   	pop    %ebp
8010271c:	c3                   	ret
8010271d:	8d 76 00             	lea    0x0(%esi),%esi

80102720 <kinit1>:
{
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
80102723:	56                   	push   %esi
80102724:	53                   	push   %ebx
80102725:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102728:	83 ec 08             	sub    $0x8,%esp
8010272b:	68 b2 78 10 80       	push   $0x801078b2
80102730:	68 40 26 11 80       	push   $0x80112640
80102735:	e8 86 20 00 00       	call   801047c0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010273a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010273d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102740:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102747:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010274a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102750:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102756:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010275c:	39 de                	cmp    %ebx,%esi
8010275e:	72 1c                	jb     8010277c <kinit1+0x5c>
    kfree(p);
80102760:	83 ec 0c             	sub    $0xc,%esp
80102763:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102769:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010276f:	50                   	push   %eax
80102770:	e8 4b fe ff ff       	call   801025c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102775:	83 c4 10             	add    $0x10,%esp
80102778:	39 de                	cmp    %ebx,%esi
8010277a:	73 e4                	jae    80102760 <kinit1+0x40>
}
8010277c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010277f:	5b                   	pop    %ebx
80102780:	5e                   	pop    %esi
80102781:	5d                   	pop    %ebp
80102782:	c3                   	ret
80102783:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102788:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010278f:	00 

80102790 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102790:	a1 74 26 11 80       	mov    0x80112674,%eax
80102795:	85 c0                	test   %eax,%eax
80102797:	75 1f                	jne    801027b8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102799:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010279e:	85 c0                	test   %eax,%eax
801027a0:	74 0e                	je     801027b0 <kalloc+0x20>
    kmem.freelist = r->next;
801027a2:	8b 10                	mov    (%eax),%edx
801027a4:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801027aa:	c3                   	ret
801027ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    release(&kmem.lock);
  return (char*)r;
}
801027b0:	c3                   	ret
801027b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801027b8:	55                   	push   %ebp
801027b9:	89 e5                	mov    %esp,%ebp
801027bb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801027be:	68 40 26 11 80       	push   $0x80112640
801027c3:	e8 18 22 00 00       	call   801049e0 <acquire>
  r = kmem.freelist;
801027c8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
801027cd:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
801027d3:	83 c4 10             	add    $0x10,%esp
801027d6:	85 c0                	test   %eax,%eax
801027d8:	74 08                	je     801027e2 <kalloc+0x52>
    kmem.freelist = r->next;
801027da:	8b 08                	mov    (%eax),%ecx
801027dc:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801027e2:	85 d2                	test   %edx,%edx
801027e4:	74 16                	je     801027fc <kalloc+0x6c>
    release(&kmem.lock);
801027e6:	83 ec 0c             	sub    $0xc,%esp
801027e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027ec:	68 40 26 11 80       	push   $0x80112640
801027f1:	e8 8a 21 00 00       	call   80104980 <release>
801027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027f9:	83 c4 10             	add    $0x10,%esp
}
801027fc:	c9                   	leave
801027fd:	c3                   	ret
801027fe:	66 90                	xchg   %ax,%ax

80102800 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102800:	ba 64 00 00 00       	mov    $0x64,%edx
80102805:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102806:	a8 01                	test   $0x1,%al
80102808:	0f 84 c2 00 00 00    	je     801028d0 <kbdgetc+0xd0>
{
8010280e:	55                   	push   %ebp
8010280f:	ba 60 00 00 00       	mov    $0x60,%edx
80102814:	89 e5                	mov    %esp,%ebp
80102816:	53                   	push   %ebx
80102817:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102818:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010281e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102821:	3c e0                	cmp    $0xe0,%al
80102823:	74 53                	je     80102878 <kbdgetc+0x78>
    return 0;
  } else if(data & 0x80){
80102825:	84 c0                	test   %al,%al
80102827:	78 67                	js     80102890 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102829:	f6 c3 40             	test   $0x40,%bl
8010282c:	74 09                	je     80102837 <kbdgetc+0x37>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010282e:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102831:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102834:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102837:	0f b6 91 c0 7e 10 80 	movzbl -0x7fef8140(%ecx),%edx
  shift ^= togglecode[data];
8010283e:	0f b6 81 c0 7d 10 80 	movzbl -0x7fef8240(%ecx),%eax
  shift |= shiftcode[data];
80102845:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102847:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102849:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010284b:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102851:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102854:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102857:	8b 04 85 a0 7d 10 80 	mov    -0x7fef8260(,%eax,4),%eax
8010285e:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102862:	74 0b                	je     8010286f <kbdgetc+0x6f>
    if('a' <= c && c <= 'z')
80102864:	8d 50 9f             	lea    -0x61(%eax),%edx
80102867:	83 fa 19             	cmp    $0x19,%edx
8010286a:	77 4c                	ja     801028b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
8010286c:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010286f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102872:	c9                   	leave
80102873:	c3                   	ret
80102874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102878:	83 cb 40             	or     $0x40,%ebx
    return 0;
8010287b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010287d:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
80102883:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102886:	c9                   	leave
80102887:	c3                   	ret
80102888:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010288f:	00 
    data = (shift & E0ESC ? data : data & 0x7F);
80102890:	83 e0 7f             	and    $0x7f,%eax
80102893:	f6 c3 40             	test   $0x40,%bl
80102896:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102899:	0f b6 81 c0 7e 10 80 	movzbl -0x7fef8140(%ecx),%eax
801028a0:	83 c8 40             	or     $0x40,%eax
801028a3:	0f b6 c0             	movzbl %al,%eax
801028a6:	f7 d0                	not    %eax
801028a8:	21 d8                	and    %ebx,%eax
801028aa:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
801028af:	31 c0                	xor    %eax,%eax
801028b1:	eb d0                	jmp    80102883 <kbdgetc+0x83>
801028b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801028b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801028bb:	8d 50 20             	lea    0x20(%eax),%edx
}
801028be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028c1:	c9                   	leave
      c += 'a' - 'A';
801028c2:	83 f9 1a             	cmp    $0x1a,%ecx
801028c5:	0f 42 c2             	cmovb  %edx,%eax
}
801028c8:	c3                   	ret
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801028d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801028d5:	c3                   	ret
801028d6:	66 90                	xchg   %ax,%ax
801028d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801028df:	00 

801028e0 <kbdintr>:

void
kbdintr(void)
{
801028e0:	55                   	push   %ebp
801028e1:	89 e5                	mov    %esp,%ebp
801028e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801028e6:	68 00 28 10 80       	push   $0x80102800
801028eb:	e8 e0 df ff ff       	call   801008d0 <consoleintr>
}
801028f0:	83 c4 10             	add    $0x10,%esp
801028f3:	c9                   	leave
801028f4:	c3                   	ret
801028f5:	66 90                	xchg   %ax,%ax
801028f7:	66 90                	xchg   %ax,%ax
801028f9:	66 90                	xchg   %ax,%ax
801028fb:	66 90                	xchg   %ax,%ax
801028fd:	66 90                	xchg   %ax,%ax
801028ff:	90                   	nop

80102900 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102900:	a1 80 26 11 80       	mov    0x80112680,%eax
80102905:	85 c0                	test   %eax,%eax
80102907:	0f 84 cb 00 00 00    	je     801029d8 <lapicinit+0xd8>
  lapic[index] = value;
8010290d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102914:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102917:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010291a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102921:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102924:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102927:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010292e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102931:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102934:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010293b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010293e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102941:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102948:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010294b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010294e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102955:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102958:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010295b:	8b 50 30             	mov    0x30(%eax),%edx
8010295e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102964:	75 7a                	jne    801029e0 <lapicinit+0xe0>
  lapic[index] = value;
80102966:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010296d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102970:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102973:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010297a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010297d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102980:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102987:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010298a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010298d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102994:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102997:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010299a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801029a1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029a7:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801029ae:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801029b1:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801029b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029bf:	00 
801029c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801029c6:	80 e6 10             	and    $0x10,%dh
801029c9:	75 f5                	jne    801029c0 <lapicinit+0xc0>
  lapic[index] = value;
801029cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801029d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801029d8:	c3                   	ret
801029d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801029e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801029e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029ea:	8b 50 20             	mov    0x20(%eax),%edx
}
801029ed:	e9 74 ff ff ff       	jmp    80102966 <lapicinit+0x66>
801029f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801029f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029ff:	00 

80102a00 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102a00:	a1 80 26 11 80       	mov    0x80112680,%eax
80102a05:	85 c0                	test   %eax,%eax
80102a07:	74 07                	je     80102a10 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102a09:	8b 40 20             	mov    0x20(%eax),%eax
80102a0c:	c1 e8 18             	shr    $0x18,%eax
80102a0f:	c3                   	ret
80102a10:	31 c0                	xor    %eax,%eax
}
80102a12:	c3                   	ret
80102a13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a1f:	00 

80102a20 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102a20:	a1 80 26 11 80       	mov    0x80112680,%eax
80102a25:	85 c0                	test   %eax,%eax
80102a27:	74 0d                	je     80102a36 <lapiceoi+0x16>
  lapic[index] = value;
80102a29:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a30:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a33:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a36:	c3                   	ret
80102a37:	90                   	nop
80102a38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a3f:	00 

80102a40 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102a40:	c3                   	ret
80102a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a4f:	00 

80102a50 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a51:	b8 0f 00 00 00       	mov    $0xf,%eax
80102a56:	ba 70 00 00 00       	mov    $0x70,%edx
80102a5b:	89 e5                	mov    %esp,%ebp
80102a5d:	56                   	push   %esi
80102a5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a61:	53                   	push   %ebx
80102a62:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a65:	ee                   	out    %al,(%dx)
80102a66:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a6b:	ba 71 00 00 00       	mov    $0x71,%edx
80102a70:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a71:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102a73:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a76:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a7c:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a7e:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102a81:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a84:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a87:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a8d:	a1 80 26 11 80       	mov    0x80112680,%eax
80102a92:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a98:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a9b:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102aa2:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aa8:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102aaf:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab2:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ab5:	ba 02 00 00 00       	mov    $0x2,%edx
  lapic[index] = value;
80102aba:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ac0:	8b 70 20             	mov    0x20(%eax),%esi
  lapic[index] = value;
80102ac3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ac9:	8b 70 20             	mov    0x20(%eax),%esi
  for(i = 0; i < 2; i++){
80102acc:	83 fa 01             	cmp    $0x1,%edx
80102acf:	75 07                	jne    80102ad8 <lapicstartap+0x88>
    microdelay(200);
  }
}
80102ad1:	5b                   	pop    %ebx
80102ad2:	5e                   	pop    %esi
80102ad3:	5d                   	pop    %ebp
80102ad4:	c3                   	ret
80102ad5:	8d 76 00             	lea    0x0(%esi),%esi
80102ad8:	ba 01 00 00 00       	mov    $0x1,%edx
80102add:	eb db                	jmp    80102aba <lapicstartap+0x6a>
80102adf:	90                   	nop

80102ae0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102ae0:	55                   	push   %ebp
80102ae1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102ae6:	ba 70 00 00 00       	mov    $0x70,%edx
80102aeb:	89 e5                	mov    %esp,%ebp
80102aed:	57                   	push   %edi
80102aee:	56                   	push   %esi
80102aef:	53                   	push   %ebx
80102af0:	83 ec 4c             	sub    $0x4c,%esp
80102af3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af4:	ba 71 00 00 00       	mov    $0x71,%edx
80102af9:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102afa:	88 45 b4             	mov    %al,-0x4c(%ebp)
80102afd:	8d 76 00             	lea    0x0(%esi),%esi
80102b00:	31 c0                	xor    %eax,%eax
80102b02:	ba 70 00 00 00       	mov    $0x70,%edx
80102b07:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b08:	ba 71 00 00 00       	mov    $0x71,%edx
80102b0d:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b0e:	ba 70 00 00 00       	mov    $0x70,%edx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b13:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b16:	b8 02 00 00 00       	mov    $0x2,%eax
80102b1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1c:	ba 71 00 00 00       	mov    $0x71,%edx
80102b21:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b22:	ba 70 00 00 00       	mov    $0x70,%edx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b27:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b2a:	b8 04 00 00 00       	mov    $0x4,%eax
80102b2f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b30:	ba 71 00 00 00       	mov    $0x71,%edx
80102b35:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b36:	ba 70 00 00 00       	mov    $0x70,%edx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b3b:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b3e:	b8 07 00 00 00       	mov    $0x7,%eax
80102b43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b44:	ba 71 00 00 00       	mov    $0x71,%edx
80102b49:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b4a:	ba 70 00 00 00       	mov    $0x70,%edx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4f:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b51:	b8 08 00 00 00       	mov    $0x8,%eax
80102b56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b57:	ba 71 00 00 00       	mov    $0x71,%edx
80102b5c:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b5d:	ba 70 00 00 00       	mov    $0x70,%edx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b62:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b64:	b8 09 00 00 00       	mov    $0x9,%eax
80102b69:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b6a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b6f:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b70:	ba 70 00 00 00       	mov    $0x70,%edx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b75:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b78:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b7d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b7e:	ba 71 00 00 00       	mov    $0x71,%edx
80102b83:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b84:	84 c0                	test   %al,%al
80102b86:	0f 88 74 ff ff ff    	js     80102b00 <cmostime+0x20>
  return inb(CMOS_RETURN);
80102b8c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b90:	89 fa                	mov    %edi,%edx
80102b92:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102b95:	0f b6 fa             	movzbl %dl,%edi
80102b98:	89 f2                	mov    %esi,%edx
80102b9a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b9d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102ba1:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba4:	ba 70 00 00 00       	mov    $0x70,%edx
80102ba9:	89 7d c4             	mov    %edi,-0x3c(%ebp)
80102bac:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102baf:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102bb3:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102bb6:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102bb9:	31 c0                	xor    %eax,%eax
80102bbb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bbc:	ba 71 00 00 00       	mov    $0x71,%edx
80102bc1:	ec                   	in     (%dx),%al
80102bc2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc5:	ba 70 00 00 00       	mov    $0x70,%edx
80102bca:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102bcd:	b8 02 00 00 00       	mov    $0x2,%eax
80102bd2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bd3:	ba 71 00 00 00       	mov    $0x71,%edx
80102bd8:	ec                   	in     (%dx),%al
80102bd9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bdc:	ba 70 00 00 00       	mov    $0x70,%edx
80102be1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102be4:	b8 04 00 00 00       	mov    $0x4,%eax
80102be9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bea:	ba 71 00 00 00       	mov    $0x71,%edx
80102bef:	ec                   	in     (%dx),%al
80102bf0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf3:	ba 70 00 00 00       	mov    $0x70,%edx
80102bf8:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102bfb:	b8 07 00 00 00       	mov    $0x7,%eax
80102c00:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c01:	ba 71 00 00 00       	mov    $0x71,%edx
80102c06:	ec                   	in     (%dx),%al
80102c07:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c0a:	ba 70 00 00 00       	mov    $0x70,%edx
80102c0f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c12:	b8 08 00 00 00       	mov    $0x8,%eax
80102c17:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c18:	ba 71 00 00 00       	mov    $0x71,%edx
80102c1d:	ec                   	in     (%dx),%al
80102c1e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c21:	ba 70 00 00 00       	mov    $0x70,%edx
80102c26:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c29:	b8 09 00 00 00       	mov    $0x9,%eax
80102c2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c2f:	ba 71 00 00 00       	mov    $0x71,%edx
80102c34:	ec                   	in     (%dx),%al
80102c35:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c38:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102c3b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c3e:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c41:	6a 18                	push   $0x18
80102c43:	50                   	push   %eax
80102c44:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c47:	50                   	push   %eax
80102c48:	e8 f3 1e 00 00       	call   80104b40 <memcmp>
80102c4d:	83 c4 10             	add    $0x10,%esp
80102c50:	85 c0                	test   %eax,%eax
80102c52:	0f 85 a8 fe ff ff    	jne    80102b00 <cmostime+0x20>
      break;
  }

  // convert
  if(bcd) {
80102c58:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c5b:	f6 45 b4 04          	testb  $0x4,-0x4c(%ebp)
80102c5f:	75 78                	jne    80102cd9 <cmostime+0x1f9>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102c61:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c64:	89 c2                	mov    %eax,%edx
80102c66:	83 e0 0f             	and    $0xf,%eax
80102c69:	c1 ea 04             	shr    $0x4,%edx
80102c6c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c6f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c72:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c75:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c78:	89 c2                	mov    %eax,%edx
80102c7a:	83 e0 0f             	and    $0xf,%eax
80102c7d:	c1 ea 04             	shr    $0x4,%edx
80102c80:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c83:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c86:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c89:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c8c:	89 c2                	mov    %eax,%edx
80102c8e:	83 e0 0f             	and    $0xf,%eax
80102c91:	c1 ea 04             	shr    $0x4,%edx
80102c94:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c97:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c9a:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c9d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ca0:	89 c2                	mov    %eax,%edx
80102ca2:	83 e0 0f             	and    $0xf,%eax
80102ca5:	c1 ea 04             	shr    $0x4,%edx
80102ca8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cab:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cae:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102cb1:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cb4:	89 c2                	mov    %eax,%edx
80102cb6:	83 e0 0f             	and    $0xf,%eax
80102cb9:	c1 ea 04             	shr    $0x4,%edx
80102cbc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cbf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cc2:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102cc5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cc8:	89 c2                	mov    %eax,%edx
80102cca:	83 e0 0f             	and    $0xf,%eax
80102ccd:	c1 ea 04             	shr    $0x4,%edx
80102cd0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cd3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cd6:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102cd9:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cdc:	89 03                	mov    %eax,(%ebx)
80102cde:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ce1:	89 43 04             	mov    %eax,0x4(%ebx)
80102ce4:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ce7:	89 43 08             	mov    %eax,0x8(%ebx)
80102cea:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ced:	89 43 0c             	mov    %eax,0xc(%ebx)
80102cf0:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cf3:	89 43 10             	mov    %eax,0x10(%ebx)
80102cf6:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cf9:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102cfc:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102d03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d06:	5b                   	pop    %ebx
80102d07:	5e                   	pop    %esi
80102d08:	5f                   	pop    %edi
80102d09:	5d                   	pop    %ebp
80102d0a:	c3                   	ret
80102d0b:	66 90                	xchg   %ax,%ax
80102d0d:	66 90                	xchg   %ax,%ax
80102d0f:	66 90                	xchg   %ax,%ax
80102d11:	66 90                	xchg   %ax,%ax
80102d13:	66 90                	xchg   %ax,%ax
80102d15:	66 90                	xchg   %ax,%ax
80102d17:	66 90                	xchg   %ax,%ax
80102d19:	66 90                	xchg   %ax,%ax
80102d1b:	66 90                	xchg   %ax,%ax
80102d1d:	66 90                	xchg   %ax,%ax
80102d1f:	90                   	nop

80102d20 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d20:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102d26:	85 c9                	test   %ecx,%ecx
80102d28:	0f 8e 8a 00 00 00    	jle    80102db8 <install_trans+0x98>
{
80102d2e:	55                   	push   %ebp
80102d2f:	89 e5                	mov    %esp,%ebp
80102d31:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102d32:	31 ff                	xor    %edi,%edi
{
80102d34:	56                   	push   %esi
80102d35:	53                   	push   %ebx
80102d36:	83 ec 0c             	sub    $0xc,%esp
80102d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d40:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102d45:	83 ec 08             	sub    $0x8,%esp
80102d48:	8d 44 38 01          	lea    0x1(%eax,%edi,1),%eax
80102d4c:	50                   	push   %eax
80102d4d:	ff 35 e4 26 11 80    	push   0x801126e4
80102d53:	e8 78 d3 ff ff       	call   801000d0 <bread>
80102d58:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d5a:	58                   	pop    %eax
80102d5b:	5a                   	pop    %edx
80102d5c:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102d63:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102d69:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d6c:	e8 5f d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d71:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d74:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d76:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d79:	68 00 02 00 00       	push   $0x200
80102d7e:	50                   	push   %eax
80102d7f:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102d82:	50                   	push   %eax
80102d83:	e8 08 1e 00 00       	call   80104b90 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d88:	89 1c 24             	mov    %ebx,(%esp)
80102d8b:	e8 30 d4 ff ff       	call   801001c0 <bwrite>
    brelse(lbuf);
80102d90:	89 34 24             	mov    %esi,(%esp)
80102d93:	e8 68 d4 ff ff       	call   80100200 <brelse>
    brelse(dbuf);
80102d98:	89 1c 24             	mov    %ebx,(%esp)
80102d9b:	e8 60 d4 ff ff       	call   80100200 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102da0:	83 c4 10             	add    $0x10,%esp
80102da3:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102da9:	7f 95                	jg     80102d40 <install_trans+0x20>
  }
}
80102dab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dae:	5b                   	pop    %ebx
80102daf:	5e                   	pop    %esi
80102db0:	5f                   	pop    %edi
80102db1:	5d                   	pop    %ebp
80102db2:	c3                   	ret
80102db3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102db8:	c3                   	ret
80102db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102dc0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	53                   	push   %ebx
80102dc4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102dc7:	ff 35 d4 26 11 80    	push   0x801126d4
80102dcd:	ff 35 e4 26 11 80    	push   0x801126e4
80102dd3:	e8 f8 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102dd8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ddb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102ddd:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102de2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102de5:	85 c0                	test   %eax,%eax
80102de7:	7e 29                	jle    80102e12 <write_head+0x52>
80102de9:	31 d2                	xor    %edx,%edx
80102deb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102df0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102df7:	00 
80102df8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dff:	00 
    hb->block[i] = log.lh.block[i];
80102e00:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102e07:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e0b:	83 c2 01             	add    $0x1,%edx
80102e0e:	39 d0                	cmp    %edx,%eax
80102e10:	75 ee                	jne    80102e00 <write_head+0x40>
  }
  bwrite(buf);
80102e12:	83 ec 0c             	sub    $0xc,%esp
80102e15:	53                   	push   %ebx
80102e16:	e8 a5 d3 ff ff       	call   801001c0 <bwrite>
  brelse(buf);
80102e1b:	89 1c 24             	mov    %ebx,(%esp)
80102e1e:	e8 dd d3 ff ff       	call   80100200 <brelse>
}
80102e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e26:	83 c4 10             	add    $0x10,%esp
80102e29:	c9                   	leave
80102e2a:	c3                   	ret
80102e2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102e30 <initlog>:
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	53                   	push   %ebx
80102e34:	83 ec 2c             	sub    $0x2c,%esp
80102e37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102e3a:	68 b7 78 10 80       	push   $0x801078b7
80102e3f:	68 a0 26 11 80       	push   $0x801126a0
80102e44:	e8 77 19 00 00       	call   801047c0 <initlock>
  readsb(dev, &sb);
80102e49:	58                   	pop    %eax
80102e4a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e4d:	5a                   	pop    %edx
80102e4e:	50                   	push   %eax
80102e4f:	53                   	push   %ebx
80102e50:	e8 ab e7 ff ff       	call   80101600 <readsb>
  log.start = sb.logstart;
80102e55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102e58:	59                   	pop    %ecx
  log.dev = dev;
80102e59:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102e5f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102e62:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102e67:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102e6d:	5a                   	pop    %edx
80102e6e:	50                   	push   %eax
80102e6f:	53                   	push   %ebx
80102e70:	e8 5b d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102e75:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102e78:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102e7b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102e81:	85 db                	test   %ebx,%ebx
80102e83:	7e 2d                	jle    80102eb2 <initlog+0x82>
80102e85:	31 d2                	xor    %edx,%edx
80102e87:	eb 17                	jmp    80102ea0 <initlog+0x70>
80102e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e90:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e97:	00 
80102e98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e9f:	00 
    log.lh.block[i] = lh->block[i];
80102ea0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102ea4:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102eab:	83 c2 01             	add    $0x1,%edx
80102eae:	39 d3                	cmp    %edx,%ebx
80102eb0:	75 ee                	jne    80102ea0 <initlog+0x70>
  brelse(buf);
80102eb2:	83 ec 0c             	sub    $0xc,%esp
80102eb5:	50                   	push   %eax
80102eb6:	e8 45 d3 ff ff       	call   80100200 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102ebb:	e8 60 fe ff ff       	call   80102d20 <install_trans>
  log.lh.n = 0;
80102ec0:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102ec7:	00 00 00 
  write_head(); // clear the log
80102eca:	e8 f1 fe ff ff       	call   80102dc0 <write_head>
}
80102ecf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ed2:	83 c4 10             	add    $0x10,%esp
80102ed5:	c9                   	leave
80102ed6:	c3                   	ret
80102ed7:	90                   	nop
80102ed8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102edf:	00 

80102ee0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ee0:	55                   	push   %ebp
80102ee1:	89 e5                	mov    %esp,%ebp
80102ee3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ee6:	68 a0 26 11 80       	push   $0x801126a0
80102eeb:	e8 f0 1a 00 00       	call   801049e0 <acquire>
80102ef0:	83 c4 10             	add    $0x10,%esp
80102ef3:	eb 18                	jmp    80102f0d <begin_op+0x2d>
80102ef5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102ef8:	83 ec 08             	sub    $0x8,%esp
80102efb:	68 a0 26 11 80       	push   $0x801126a0
80102f00:	68 a0 26 11 80       	push   $0x801126a0
80102f05:	e8 f6 14 00 00       	call   80104400 <sleep>
80102f0a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f0d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102f12:	85 c0                	test   %eax,%eax
80102f14:	75 e2                	jne    80102ef8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f16:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102f1b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102f21:	83 c0 01             	add    $0x1,%eax
80102f24:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f27:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f2a:	83 fa 1e             	cmp    $0x1e,%edx
80102f2d:	7f c9                	jg     80102ef8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f2f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f32:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102f37:	68 a0 26 11 80       	push   $0x801126a0
80102f3c:	e8 3f 1a 00 00       	call   80104980 <release>
      break;
    }
  }
}
80102f41:	83 c4 10             	add    $0x10,%esp
80102f44:	c9                   	leave
80102f45:	c3                   	ret
80102f46:	66 90                	xchg   %ax,%ax
80102f48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f4f:	00 

80102f50 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	57                   	push   %edi
80102f54:	56                   	push   %esi
80102f55:	53                   	push   %ebx
80102f56:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f59:	68 a0 26 11 80       	push   $0x801126a0
80102f5e:	e8 7d 1a 00 00       	call   801049e0 <acquire>
  log.outstanding -= 1;
80102f63:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102f68:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102f6e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102f71:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102f74:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102f7a:	85 f6                	test   %esi,%esi
80102f7c:	0f 85 22 01 00 00    	jne    801030a4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102f82:	85 db                	test   %ebx,%ebx
80102f84:	0f 85 f6 00 00 00    	jne    80103080 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102f8a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102f91:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f94:	83 ec 0c             	sub    $0xc,%esp
80102f97:	68 a0 26 11 80       	push   $0x801126a0
80102f9c:	e8 df 19 00 00       	call   80104980 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fa1:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102fa7:	83 c4 10             	add    $0x10,%esp
80102faa:	85 c9                	test   %ecx,%ecx
80102fac:	7f 42                	jg     80102ff0 <end_op+0xa0>
    acquire(&log.lock);
80102fae:	83 ec 0c             	sub    $0xc,%esp
80102fb1:	68 a0 26 11 80       	push   $0x801126a0
80102fb6:	e8 25 1a 00 00       	call   801049e0 <acquire>
    log.committing = 0;
80102fbb:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102fc2:	00 00 00 
    wakeup(&log);
80102fc5:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102fcc:	e8 0f 15 00 00       	call   801044e0 <wakeup>
    release(&log.lock);
80102fd1:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102fd8:	e8 a3 19 00 00       	call   80104980 <release>
80102fdd:	83 c4 10             	add    $0x10,%esp
}
80102fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fe3:	5b                   	pop    %ebx
80102fe4:	5e                   	pop    %esi
80102fe5:	5f                   	pop    %edi
80102fe6:	5d                   	pop    %ebp
80102fe7:	c3                   	ret
80102fe8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102fef:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ff0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102ff5:	83 ec 08             	sub    $0x8,%esp
80102ff8:	8d 44 18 01          	lea    0x1(%eax,%ebx,1),%eax
80102ffc:	50                   	push   %eax
80102ffd:	ff 35 e4 26 11 80    	push   0x801126e4
80103003:	e8 c8 d0 ff ff       	call   801000d0 <bread>
80103008:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010300a:	58                   	pop    %eax
8010300b:	5a                   	pop    %edx
8010300c:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80103013:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80103019:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010301c:	e8 af d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103021:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103024:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103026:	8d 40 5c             	lea    0x5c(%eax),%eax
80103029:	68 00 02 00 00       	push   $0x200
8010302e:	50                   	push   %eax
8010302f:	8d 46 5c             	lea    0x5c(%esi),%eax
80103032:	50                   	push   %eax
80103033:	e8 58 1b 00 00       	call   80104b90 <memmove>
    bwrite(to);  // write the log
80103038:	89 34 24             	mov    %esi,(%esp)
8010303b:	e8 80 d1 ff ff       	call   801001c0 <bwrite>
    brelse(from);
80103040:	89 3c 24             	mov    %edi,(%esp)
80103043:	e8 b8 d1 ff ff       	call   80100200 <brelse>
    brelse(to);
80103048:	89 34 24             	mov    %esi,(%esp)
8010304b:	e8 b0 d1 ff ff       	call   80100200 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103050:	83 c4 10             	add    $0x10,%esp
80103053:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80103059:	7c 95                	jl     80102ff0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010305b:	e8 60 fd ff ff       	call   80102dc0 <write_head>
    install_trans(); // Now install writes to home locations
80103060:	e8 bb fc ff ff       	call   80102d20 <install_trans>
    log.lh.n = 0;
80103065:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
8010306c:	00 00 00 
    write_head();    // Erase the transaction from the log
8010306f:	e8 4c fd ff ff       	call   80102dc0 <write_head>
80103074:	e9 35 ff ff ff       	jmp    80102fae <end_op+0x5e>
80103079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103080:	83 ec 0c             	sub    $0xc,%esp
80103083:	68 a0 26 11 80       	push   $0x801126a0
80103088:	e8 53 14 00 00       	call   801044e0 <wakeup>
  release(&log.lock);
8010308d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80103094:	e8 e7 18 00 00       	call   80104980 <release>
80103099:	83 c4 10             	add    $0x10,%esp
}
8010309c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010309f:	5b                   	pop    %ebx
801030a0:	5e                   	pop    %esi
801030a1:	5f                   	pop    %edi
801030a2:	5d                   	pop    %ebp
801030a3:	c3                   	ret
    panic("log.committing");
801030a4:	83 ec 0c             	sub    $0xc,%esp
801030a7:	68 bb 78 10 80       	push   $0x801078bb
801030ac:	e8 ef d2 ff ff       	call   801003a0 <panic>
801030b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801030bf:	00 

801030c0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030c0:	55                   	push   %ebp
801030c1:	89 e5                	mov    %esp,%ebp
801030c3:	53                   	push   %ebx
801030c4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030c7:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
801030cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030d0:	83 fa 1d             	cmp    $0x1d,%edx
801030d3:	7f 7d                	jg     80103152 <log_write+0x92>
801030d5:	a1 d8 26 11 80       	mov    0x801126d8,%eax
801030da:	83 e8 01             	sub    $0x1,%eax
801030dd:	39 c2                	cmp    %eax,%edx
801030df:	7d 71                	jge    80103152 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
801030e1:	a1 dc 26 11 80       	mov    0x801126dc,%eax
801030e6:	85 c0                	test   %eax,%eax
801030e8:	7e 75                	jle    8010315f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
801030ea:	83 ec 0c             	sub    $0xc,%esp
801030ed:	68 a0 26 11 80       	push   $0x801126a0
801030f2:	e8 e9 18 00 00       	call   801049e0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
801030f7:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801030fa:	83 c4 10             	add    $0x10,%esp
801030fd:	31 c0                	xor    %eax,%eax
801030ff:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80103105:	85 d2                	test   %edx,%edx
80103107:	7f 0e                	jg     80103117 <log_write+0x57>
80103109:	eb 15                	jmp    80103120 <log_write+0x60>
8010310b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103110:	83 c0 01             	add    $0x1,%eax
80103113:	39 d0                	cmp    %edx,%eax
80103115:	74 29                	je     80103140 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103117:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
8010311e:	75 f0                	jne    80103110 <log_write+0x50>
  log.lh.block[i] = b->blockno;
80103120:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
80103127:	39 c2                	cmp    %eax,%edx
80103129:	74 1c                	je     80103147 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010312b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010312e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103131:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80103138:	c9                   	leave
  release(&log.lock);
80103139:	e9 42 18 00 00       	jmp    80104980 <release>
8010313e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103140:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80103147:	83 c2 01             	add    $0x1,%edx
8010314a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80103150:	eb d9                	jmp    8010312b <log_write+0x6b>
    panic("too big a transaction");
80103152:	83 ec 0c             	sub    $0xc,%esp
80103155:	68 ca 78 10 80       	push   $0x801078ca
8010315a:	e8 41 d2 ff ff       	call   801003a0 <panic>
    panic("log_write outside of trans");
8010315f:	83 ec 0c             	sub    $0xc,%esp
80103162:	68 e0 78 10 80       	push   $0x801078e0
80103167:	e8 34 d2 ff ff       	call   801003a0 <panic>
8010316c:	66 90                	xchg   %ax,%ax
8010316e:	66 90                	xchg   %ax,%ax

80103170 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	53                   	push   %ebx
80103174:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103177:	e8 04 0a 00 00       	call   80103b80 <cpuid>
8010317c:	89 c3                	mov    %eax,%ebx
8010317e:	e8 fd 09 00 00       	call   80103b80 <cpuid>
80103183:	83 ec 04             	sub    $0x4,%esp
80103186:	53                   	push   %ebx
80103187:	50                   	push   %eax
80103188:	68 fb 78 10 80       	push   $0x801078fb
8010318d:	e8 3e d5 ff ff       	call   801006d0 <cprintf>
  idtinit();       // load idt register
80103192:	e8 59 2c 00 00       	call   80105df0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103197:	e8 64 09 00 00       	call   80103b00 <mycpu>
8010319c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010319e:	b8 01 00 00 00       	mov    $0x1,%eax
801031a3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801031aa:	e8 b1 0c 00 00       	call   80103e60 <scheduler>
801031af:	90                   	nop

801031b0 <mpenter>:
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801031b6:	e8 a5 3d 00 00       	call   80106f60 <switchkvm>
  seginit();
801031bb:	e8 10 3d 00 00       	call   80106ed0 <seginit>
  lapicinit();
801031c0:	e8 3b f7 ff ff       	call   80102900 <lapicinit>
  mpmain();
801031c5:	e8 a6 ff ff ff       	call   80103170 <mpmain>
801031ca:	66 90                	xchg   %ax,%ax
801031cc:	66 90                	xchg   %ax,%ax
801031ce:	66 90                	xchg   %ax,%ax

801031d0 <main>:
{
801031d0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801031d4:	83 e4 f0             	and    $0xfffffff0,%esp
801031d7:	ff 71 fc             	push   -0x4(%ecx)
801031da:	55                   	push   %ebp
801031db:	89 e5                	mov    %esp,%ebp
801031dd:	53                   	push   %ebx
801031de:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801031df:	83 ec 08             	sub    $0x8,%esp
801031e2:	68 00 00 40 80       	push   $0x80400000
801031e7:	68 d0 66 11 80       	push   $0x801166d0
801031ec:	e8 2f f5 ff ff       	call   80102720 <kinit1>
  kvmalloc();      // kernel page table
801031f1:	e8 2a 42 00 00       	call   80107420 <kvmalloc>
  mpinit();        // detect other processors
801031f6:	e8 85 01 00 00       	call   80103380 <mpinit>
  lapicinit();     // interrupt controller
801031fb:	e8 00 f7 ff ff       	call   80102900 <lapicinit>
  seginit();       // segment descriptors
80103200:	e8 cb 3c 00 00       	call   80106ed0 <seginit>
  picinit();       // disable pic
80103205:	e8 76 03 00 00       	call   80103580 <picinit>
  ioapicinit();    // another interrupt controller
8010320a:	e8 b1 f2 ff ff       	call   801024c0 <ioapicinit>
  consoleinit();   // console hardware
8010320f:	e8 ac d8 ff ff       	call   80100ac0 <consoleinit>
  uartinit();      // serial port
80103214:	e8 37 2f 00 00       	call   80106150 <uartinit>
  pinit();         // process table
80103219:	e8 c2 08 00 00       	call   80103ae0 <pinit>
  tvinit();        // trap vectors
8010321e:	e8 1d 2b 00 00       	call   80105d40 <tvinit>
  binit();         // buffer cache
80103223:	e8 18 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103228:	e8 73 dc ff ff       	call   80100ea0 <fileinit>
  ideinit();       // disk 
8010322d:	e8 6e f0 ff ff       	call   801022a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103232:	83 c4 0c             	add    $0xc,%esp
80103235:	68 8a 00 00 00       	push   $0x8a
8010323a:	68 8c b4 10 80       	push   $0x8010b48c
8010323f:	68 00 70 00 80       	push   $0x80007000
80103244:	e8 47 19 00 00       	call   80104b90 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103249:	83 c4 10             	add    $0x10,%esp
8010324c:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103253:	00 00 00 
80103256:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010325b:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80103260:	76 7e                	jbe    801032e0 <main+0x110>
80103262:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80103267:	eb 20                	jmp    80103289 <main+0xb9>
80103269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103270:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103277:	00 00 00 
8010327a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103280:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103285:	39 c3                	cmp    %eax,%ebx
80103287:	73 57                	jae    801032e0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103289:	e8 72 08 00 00       	call   80103b00 <mycpu>
8010328e:	39 d8                	cmp    %ebx,%eax
80103290:	74 de                	je     80103270 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103292:	e8 f9 f4 ff ff       	call   80102790 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103297:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010329a:	c7 05 f8 6f 00 80 b0 	movl   $0x801031b0,0x80006ff8
801032a1:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032a4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801032ab:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801032ae:	05 00 10 00 00       	add    $0x1000,%eax
801032b3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801032b8:	0f b6 03             	movzbl (%ebx),%eax
801032bb:	68 00 70 00 00       	push   $0x7000
801032c0:	50                   	push   %eax
801032c1:	e8 8a f7 ff ff       	call   80102a50 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801032c6:	83 c4 10             	add    $0x10,%esp
801032c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032d0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801032d6:	85 c0                	test   %eax,%eax
801032d8:	74 f6                	je     801032d0 <main+0x100>
801032da:	eb 94                	jmp    80103270 <main+0xa0>
801032dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801032e0:	83 ec 08             	sub    $0x8,%esp
801032e3:	68 00 00 00 8e       	push   $0x8e000000
801032e8:	68 00 00 40 80       	push   $0x80400000
801032ed:	e8 ce f3 ff ff       	call   801026c0 <kinit2>
  userinit();      // first user process
801032f2:	e8 d9 08 00 00       	call   80103bd0 <userinit>
  mpmain();        // finish this processor's setup
801032f7:	e8 74 fe ff ff       	call   80103170 <mpmain>
801032fc:	66 90                	xchg   %ax,%ax
801032fe:	66 90                	xchg   %ax,%ax

80103300 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	57                   	push   %edi
80103304:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103305:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010330b:	53                   	push   %ebx
  e = addr+len;
8010330c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010330f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103312:	39 de                	cmp    %ebx,%esi
80103314:	72 10                	jb     80103326 <mpsearch1+0x26>
80103316:	eb 58                	jmp    80103370 <mpsearch1+0x70>
80103318:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010331f:	00 
80103320:	89 fe                	mov    %edi,%esi
80103322:	39 df                	cmp    %ebx,%edi
80103324:	73 4a                	jae    80103370 <mpsearch1+0x70>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103326:	83 ec 04             	sub    $0x4,%esp
80103329:	8d 7e 10             	lea    0x10(%esi),%edi
8010332c:	6a 04                	push   $0x4
8010332e:	68 0f 79 10 80       	push   $0x8010790f
80103333:	56                   	push   %esi
80103334:	e8 07 18 00 00       	call   80104b40 <memcmp>
80103339:	83 c4 10             	add    $0x10,%esp
8010333c:	85 c0                	test   %eax,%eax
8010333e:	75 e0                	jne    80103320 <mpsearch1+0x20>
80103340:	89 f2                	mov    %esi,%edx
80103342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103348:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010334f:	00 
    sum += addr[i];
80103350:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103353:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103356:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103358:	39 fa                	cmp    %edi,%edx
8010335a:	75 f4                	jne    80103350 <mpsearch1+0x50>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010335c:	84 c0                	test   %al,%al
8010335e:	75 c0                	jne    80103320 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103363:	89 f0                	mov    %esi,%eax
80103365:	5b                   	pop    %ebx
80103366:	5e                   	pop    %esi
80103367:	5f                   	pop    %edi
80103368:	5d                   	pop    %ebp
80103369:	c3                   	ret
8010336a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103370:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103373:	31 f6                	xor    %esi,%esi
}
80103375:	5b                   	pop    %ebx
80103376:	89 f0                	mov    %esi,%eax
80103378:	5e                   	pop    %esi
80103379:	5f                   	pop    %edi
8010337a:	5d                   	pop    %ebp
8010337b:	c3                   	ret
8010337c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103380 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103380:	55                   	push   %ebp
80103381:	89 e5                	mov    %esp,%ebp
80103383:	57                   	push   %edi
80103384:	56                   	push   %esi
80103385:	53                   	push   %ebx
80103386:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103389:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103390:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103397:	c1 e0 08             	shl    $0x8,%eax
8010339a:	09 d0                	or     %edx,%eax
8010339c:	c1 e0 04             	shl    $0x4,%eax
8010339f:	75 1b                	jne    801033bc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801033a1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801033a8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801033af:	c1 e0 08             	shl    $0x8,%eax
801033b2:	09 d0                	or     %edx,%eax
801033b4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801033b7:	2d 00 04 00 00       	sub    $0x400,%eax
801033bc:	ba 00 04 00 00       	mov    $0x400,%edx
801033c1:	e8 3a ff ff ff       	call   80103300 <mpsearch1>
801033c6:	85 c0                	test   %eax,%eax
801033c8:	0f 84 5a 01 00 00    	je     80103528 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801033d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801033d4:	8b 40 04             	mov    0x4(%eax),%eax
801033d7:	85 c0                	test   %eax,%eax
801033d9:	0f 84 d1 00 00 00    	je     801034b0 <mpinit+0x130>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801033df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801033e2:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801033e5:	8b 40 04             	mov    0x4(%eax),%eax
801033e8:	05 00 00 00 80       	add    $0x80000000,%eax
801033ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801033f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801033f3:	6a 04                	push   $0x4
801033f5:	68 2c 79 10 80       	push   $0x8010792c
801033fa:	50                   	push   %eax
801033fb:	e8 40 17 00 00       	call   80104b40 <memcmp>
80103400:	83 c4 10             	add    $0x10,%esp
80103403:	89 c2                	mov    %eax,%edx
80103405:	85 c0                	test   %eax,%eax
80103407:	0f 85 a3 00 00 00    	jne    801034b0 <mpinit+0x130>
  if(conf->version != 1 && conf->version != 4)
8010340d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103410:	80 78 06 01          	cmpb   $0x1,0x6(%eax)
80103414:	74 0d                	je     80103423 <mpinit+0xa3>
80103416:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103419:	80 78 06 04          	cmpb   $0x4,0x6(%eax)
8010341d:	0f 85 8d 00 00 00    	jne    801034b0 <mpinit+0x130>
  if(sum((uchar*)conf, conf->length) != 0)
80103423:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103426:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
8010342a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  for(i=0; i<len; i++)
8010342d:	66 85 c9             	test   %cx,%cx
80103430:	74 1e                	je     80103450 <mpinit+0xd0>
80103432:	8d 1c 08             	lea    (%eax,%ecx,1),%ebx
80103435:	8d 76 00             	lea    0x0(%esi),%esi
80103438:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010343f:	00 
    sum += addr[i];
80103440:	0f b6 08             	movzbl (%eax),%ecx
  for(i=0; i<len; i++)
80103443:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103446:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103448:	39 d8                	cmp    %ebx,%eax
8010344a:	75 f4                	jne    80103440 <mpinit+0xc0>
  if(sum((uchar*)conf, conf->length) != 0)
8010344c:	84 d2                	test   %dl,%dl
8010344e:	75 60                	jne    801034b0 <mpinit+0x130>
  *pmp = mp;
80103450:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  return conf;
80103453:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103456:	85 c9                	test   %ecx,%ecx
80103458:	74 56                	je     801034b0 <mpinit+0x130>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010345a:	8b 41 24             	mov    0x24(%ecx),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010345d:	0f b7 51 04          	movzwl 0x4(%ecx),%edx
  lapic = (uint*)conf->lapicaddr;
80103461:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103466:	8d 41 2c             	lea    0x2c(%ecx),%eax
80103469:	01 d1                	add    %edx,%ecx
8010346b:	39 c8                	cmp    %ecx,%eax
8010346d:	72 14                	jb     80103483 <mpinit+0x103>
8010346f:	eb 60                	jmp    801034d1 <mpinit+0x151>
80103471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103478:	84 d2                	test   %dl,%dl
8010347a:	74 7c                	je     801034f8 <mpinit+0x178>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010347c:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010347f:	39 c8                	cmp    %ecx,%eax
80103481:	73 4e                	jae    801034d1 <mpinit+0x151>
    switch(*p){
80103483:	0f b6 10             	movzbl (%eax),%edx
80103486:	80 fa 02             	cmp    $0x2,%dl
80103489:	74 35                	je     801034c0 <mpinit+0x140>
8010348b:	76 eb                	jbe    80103478 <mpinit+0xf8>
8010348d:	83 ea 03             	sub    $0x3,%edx
80103490:	80 fa 01             	cmp    $0x1,%dl
80103493:	76 e7                	jbe    8010347c <mpinit+0xfc>
80103495:	eb fe                	jmp    80103495 <mpinit+0x115>
80103497:	90                   	nop
80103498:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010349f:	00 
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801034a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801034a7:	90                   	nop
801034a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801034af:	00 
    panic("Expect to run on an SMP");
801034b0:	83 ec 0c             	sub    $0xc,%esp
801034b3:	68 14 79 10 80       	push   $0x80107914
801034b8:	e8 e3 ce ff ff       	call   801003a0 <panic>
801034bd:	8d 76 00             	lea    0x0(%esi),%esi
      ioapicid = ioapic->apicno;
801034c0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801034c4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801034c7:	88 15 80 27 11 80    	mov    %dl,0x80112780
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034cd:	39 c8                	cmp    %ecx,%eax
801034cf:	72 b2                	jb     80103483 <mpinit+0x103>
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034d1:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801034d5:	74 15                	je     801034ec <mpinit+0x16c>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034d7:	b8 70 00 00 00       	mov    $0x70,%eax
801034dc:	ba 22 00 00 00       	mov    $0x22,%edx
801034e1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034e2:	ba 23 00 00 00       	mov    $0x23,%edx
801034e7:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801034e8:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034eb:	ee                   	out    %al,(%dx)
  }
}
801034ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034ef:	5b                   	pop    %ebx
801034f0:	5e                   	pop    %esi
801034f1:	5f                   	pop    %edi
801034f2:	5d                   	pop    %ebp
801034f3:	c3                   	ret
801034f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
801034f8:	8b 35 84 27 11 80    	mov    0x80112784,%esi
801034fe:	83 fe 07             	cmp    $0x7,%esi
80103501:	7f 19                	jg     8010351c <mpinit+0x19c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103503:	69 fe b0 00 00 00    	imul   $0xb0,%esi,%edi
80103509:	0f b6 50 01          	movzbl 0x1(%eax),%edx
        ncpu++;
8010350d:	83 c6 01             	add    $0x1,%esi
80103510:	89 35 84 27 11 80    	mov    %esi,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103516:	88 97 a0 27 11 80    	mov    %dl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
8010351c:	83 c0 14             	add    $0x14,%eax
      continue;
8010351f:	e9 5b ff ff ff       	jmp    8010347f <mpinit+0xff>
80103524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
80103528:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010352d:	eb 0f                	jmp    8010353e <mpinit+0x1be>
8010352f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103530:	89 f3                	mov    %esi,%ebx
80103532:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103538:	0f 84 62 ff ff ff    	je     801034a0 <mpinit+0x120>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010353e:	83 ec 04             	sub    $0x4,%esp
80103541:	8d 73 10             	lea    0x10(%ebx),%esi
80103544:	6a 04                	push   $0x4
80103546:	68 0f 79 10 80       	push   $0x8010790f
8010354b:	53                   	push   %ebx
8010354c:	e8 ef 15 00 00       	call   80104b40 <memcmp>
80103551:	83 c4 10             	add    $0x10,%esp
80103554:	85 c0                	test   %eax,%eax
80103556:	75 d8                	jne    80103530 <mpinit+0x1b0>
80103558:	89 da                	mov    %ebx,%edx
8010355a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103560:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103563:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103566:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103568:	39 d6                	cmp    %edx,%esi
8010356a:	75 f4                	jne    80103560 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010356c:	84 c0                	test   %al,%al
8010356e:	75 c0                	jne    80103530 <mpinit+0x1b0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103570:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103573:	e9 59 fe ff ff       	jmp    801033d1 <mpinit+0x51>
80103578:	66 90                	xchg   %ax,%ax
8010357a:	66 90                	xchg   %ax,%ax
8010357c:	66 90                	xchg   %ax,%ax
8010357e:	66 90                	xchg   %ax,%ax

80103580 <picinit>:
80103580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103585:	ba 21 00 00 00       	mov    $0x21,%edx
8010358a:	ee                   	out    %al,(%dx)
8010358b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103590:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103591:	c3                   	ret
80103592:	66 90                	xchg   %ax,%ax
80103594:	66 90                	xchg   %ax,%ax
80103596:	66 90                	xchg   %ax,%ax
80103598:	66 90                	xchg   %ax,%ax
8010359a:	66 90                	xchg   %ax,%ax
8010359c:	66 90                	xchg   %ax,%ax
8010359e:	66 90                	xchg   %ax,%ax
801035a0:	66 90                	xchg   %ax,%ax
801035a2:	66 90                	xchg   %ax,%ax
801035a4:	66 90                	xchg   %ax,%ax
801035a6:	66 90                	xchg   %ax,%ax
801035a8:	66 90                	xchg   %ax,%ax
801035aa:	66 90                	xchg   %ax,%ax
801035ac:	66 90                	xchg   %ax,%ax
801035ae:	66 90                	xchg   %ax,%ax
801035b0:	66 90                	xchg   %ax,%ax
801035b2:	66 90                	xchg   %ax,%ax
801035b4:	66 90                	xchg   %ax,%ax
801035b6:	66 90                	xchg   %ax,%ax
801035b8:	66 90                	xchg   %ax,%ax
801035ba:	66 90                	xchg   %ax,%ax
801035bc:	66 90                	xchg   %ax,%ax
801035be:	66 90                	xchg   %ax,%ax

801035c0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	57                   	push   %edi
801035c4:	56                   	push   %esi
801035c5:	53                   	push   %ebx
801035c6:	83 ec 0c             	sub    $0xc,%esp
801035c9:	8b 75 08             	mov    0x8(%ebp),%esi
801035cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801035cf:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801035d5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801035db:	e8 e0 d8 ff ff       	call   80100ec0 <filealloc>
801035e0:	89 06                	mov    %eax,(%esi)
801035e2:	85 c0                	test   %eax,%eax
801035e4:	0f 84 a5 00 00 00    	je     8010368f <pipealloc+0xcf>
801035ea:	e8 d1 d8 ff ff       	call   80100ec0 <filealloc>
801035ef:	89 07                	mov    %eax,(%edi)
801035f1:	85 c0                	test   %eax,%eax
801035f3:	0f 84 84 00 00 00    	je     8010367d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801035f9:	e8 92 f1 ff ff       	call   80102790 <kalloc>
801035fe:	89 c3                	mov    %eax,%ebx
80103600:	85 c0                	test   %eax,%eax
80103602:	0f 84 a0 00 00 00    	je     801036a8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103608:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010360f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103612:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103615:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010361c:	00 00 00 
  p->nwrite = 0;
8010361f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103626:	00 00 00 
  p->nread = 0;
80103629:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103630:	00 00 00 
  initlock(&p->lock, "pipe");
80103633:	68 31 79 10 80       	push   $0x80107931
80103638:	50                   	push   %eax
80103639:	e8 82 11 00 00       	call   801047c0 <initlock>
  (*f0)->type = FD_PIPE;
8010363e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103640:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103643:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103649:	8b 06                	mov    (%esi),%eax
8010364b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010364f:	8b 06                	mov    (%esi),%eax
80103651:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103655:	8b 06                	mov    (%esi),%eax
80103657:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010365a:	8b 07                	mov    (%edi),%eax
8010365c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103662:	8b 07                	mov    (%edi),%eax
80103664:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103668:	8b 07                	mov    (%edi),%eax
8010366a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010366e:	8b 07                	mov    (%edi),%eax
80103670:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103673:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103675:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103678:	5b                   	pop    %ebx
80103679:	5e                   	pop    %esi
8010367a:	5f                   	pop    %edi
8010367b:	5d                   	pop    %ebp
8010367c:	c3                   	ret
  if(*f0)
8010367d:	8b 06                	mov    (%esi),%eax
8010367f:	85 c0                	test   %eax,%eax
80103681:	74 1e                	je     801036a1 <pipealloc+0xe1>
    fileclose(*f0);
80103683:	83 ec 0c             	sub    $0xc,%esp
80103686:	50                   	push   %eax
80103687:	e8 f4 d8 ff ff       	call   80100f80 <fileclose>
8010368c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010368f:	8b 07                	mov    (%edi),%eax
80103691:	85 c0                	test   %eax,%eax
80103693:	74 0c                	je     801036a1 <pipealloc+0xe1>
    fileclose(*f1);
80103695:	83 ec 0c             	sub    $0xc,%esp
80103698:	50                   	push   %eax
80103699:	e8 e2 d8 ff ff       	call   80100f80 <fileclose>
8010369e:	83 c4 10             	add    $0x10,%esp
  return -1;
801036a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801036a6:	eb cd                	jmp    80103675 <pipealloc+0xb5>
  if(*f0)
801036a8:	8b 06                	mov    (%esi),%eax
801036aa:	85 c0                	test   %eax,%eax
801036ac:	75 d5                	jne    80103683 <pipealloc+0xc3>
801036ae:	eb df                	jmp    8010368f <pipealloc+0xcf>

801036b0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	56                   	push   %esi
801036b4:	53                   	push   %ebx
801036b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801036bb:	83 ec 0c             	sub    $0xc,%esp
801036be:	53                   	push   %ebx
801036bf:	e8 1c 13 00 00       	call   801049e0 <acquire>
  if(writable){
801036c4:	83 c4 10             	add    $0x10,%esp
801036c7:	85 f6                	test   %esi,%esi
801036c9:	74 45                	je     80103710 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801036cb:	83 ec 0c             	sub    $0xc,%esp
801036ce:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801036d4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801036db:	00 00 00 
    wakeup(&p->nread);
801036de:	50                   	push   %eax
801036df:	e8 fc 0d 00 00       	call   801044e0 <wakeup>
801036e4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801036e7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801036ed:	85 d2                	test   %edx,%edx
801036ef:	75 0a                	jne    801036fb <pipeclose+0x4b>
801036f1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801036f7:	85 c0                	test   %eax,%eax
801036f9:	74 35                	je     80103730 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801036fb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801036fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103701:	5b                   	pop    %ebx
80103702:	5e                   	pop    %esi
80103703:	5d                   	pop    %ebp
    release(&p->lock);
80103704:	e9 77 12 00 00       	jmp    80104980 <release>
80103709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103710:	83 ec 0c             	sub    $0xc,%esp
80103713:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103719:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103720:	00 00 00 
    wakeup(&p->nwrite);
80103723:	50                   	push   %eax
80103724:	e8 b7 0d 00 00       	call   801044e0 <wakeup>
80103729:	83 c4 10             	add    $0x10,%esp
8010372c:	eb b9                	jmp    801036e7 <pipeclose+0x37>
8010372e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103730:	83 ec 0c             	sub    $0xc,%esp
80103733:	53                   	push   %ebx
80103734:	e8 47 12 00 00       	call   80104980 <release>
    kfree((char*)p);
80103739:	83 c4 10             	add    $0x10,%esp
8010373c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010373f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103742:	5b                   	pop    %ebx
80103743:	5e                   	pop    %esi
80103744:	5d                   	pop    %ebp
    kfree((char*)p);
80103745:	e9 76 ee ff ff       	jmp    801025c0 <kfree>
8010374a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103750 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	57                   	push   %edi
80103754:	56                   	push   %esi
80103755:	53                   	push   %ebx
80103756:	83 ec 28             	sub    $0x28,%esp
80103759:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010375c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010375f:	53                   	push   %ebx
80103760:	e8 7b 12 00 00       	call   801049e0 <acquire>
  for(i = 0; i < n; i++){
80103765:	83 c4 10             	add    $0x10,%esp
80103768:	85 ff                	test   %edi,%edi
8010376a:	0f 8e cc 00 00 00    	jle    8010383c <pipewrite+0xec>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103770:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103776:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103779:	89 7d 10             	mov    %edi,0x10(%ebp)
8010377c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010377f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103782:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103785:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010378b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103791:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103797:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010379d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801037a0:	0f 85 b4 00 00 00    	jne    8010385a <pipewrite+0x10a>
801037a6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801037a9:	eb 3b                	jmp    801037e6 <pipewrite+0x96>
801037ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801037b0:	e8 eb 03 00 00       	call   80103ba0 <myproc>
801037b5:	8b 48 24             	mov    0x24(%eax),%ecx
801037b8:	85 c9                	test   %ecx,%ecx
801037ba:	75 34                	jne    801037f0 <pipewrite+0xa0>
      wakeup(&p->nread);
801037bc:	83 ec 0c             	sub    $0xc,%esp
801037bf:	56                   	push   %esi
801037c0:	e8 1b 0d 00 00       	call   801044e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037c5:	58                   	pop    %eax
801037c6:	5a                   	pop    %edx
801037c7:	53                   	push   %ebx
801037c8:	57                   	push   %edi
801037c9:	e8 32 0c 00 00       	call   80104400 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037ce:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801037d4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801037da:	83 c4 10             	add    $0x10,%esp
801037dd:	05 00 02 00 00       	add    $0x200,%eax
801037e2:	39 c2                	cmp    %eax,%edx
801037e4:	75 2a                	jne    80103810 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801037e6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037ec:	85 c0                	test   %eax,%eax
801037ee:	75 c0                	jne    801037b0 <pipewrite+0x60>
        release(&p->lock);
801037f0:	83 ec 0c             	sub    $0xc,%esp
801037f3:	53                   	push   %ebx
801037f4:	e8 87 11 00 00       	call   80104980 <release>
        return -1;
801037f9:	83 c4 10             	add    $0x10,%esp
801037fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103801:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103804:	5b                   	pop    %ebx
80103805:	5e                   	pop    %esi
80103806:	5f                   	pop    %edi
80103807:	5d                   	pop    %ebp
80103808:	c3                   	ret
80103809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103810:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103813:	8d 42 01             	lea    0x1(%edx),%eax
80103816:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010381c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010381f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103825:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103828:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010382c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103830:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103833:	0f 85 52 ff ff ff    	jne    8010378b <pipewrite+0x3b>
80103839:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010383c:	83 ec 0c             	sub    $0xc,%esp
8010383f:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103845:	50                   	push   %eax
80103846:	e8 95 0c 00 00       	call   801044e0 <wakeup>
  release(&p->lock);
8010384b:	89 1c 24             	mov    %ebx,(%esp)
8010384e:	e8 2d 11 00 00       	call   80104980 <release>
  return n;
80103853:	83 c4 10             	add    $0x10,%esp
80103856:	89 f8                	mov    %edi,%eax
80103858:	eb a7                	jmp    80103801 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010385a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010385d:	eb b4                	jmp    80103813 <pipewrite+0xc3>
8010385f:	90                   	nop

80103860 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	57                   	push   %edi
80103864:	56                   	push   %esi
80103865:	53                   	push   %ebx
80103866:	83 ec 18             	sub    $0x18,%esp
80103869:	8b 75 08             	mov    0x8(%ebp),%esi
8010386c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010386f:	56                   	push   %esi
80103870:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103876:	e8 65 11 00 00       	call   801049e0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010387b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103881:	83 c4 10             	add    $0x10,%esp
80103884:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010388a:	74 2f                	je     801038bb <piperead+0x5b>
8010388c:	eb 37                	jmp    801038c5 <piperead+0x65>
8010388e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103890:	e8 0b 03 00 00       	call   80103ba0 <myproc>
80103895:	8b 40 24             	mov    0x24(%eax),%eax
80103898:	85 c0                	test   %eax,%eax
8010389a:	0f 85 b0 00 00 00    	jne    80103950 <piperead+0xf0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038a0:	83 ec 08             	sub    $0x8,%esp
801038a3:	56                   	push   %esi
801038a4:	53                   	push   %ebx
801038a5:	e8 56 0b 00 00       	call   80104400 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038aa:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038b0:	83 c4 10             	add    $0x10,%esp
801038b3:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801038b9:	75 0a                	jne    801038c5 <piperead+0x65>
801038bb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801038c1:	85 d2                	test   %edx,%edx
801038c3:	75 cb                	jne    80103890 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801038c8:	31 db                	xor    %ebx,%ebx
801038ca:	85 c9                	test   %ecx,%ecx
801038cc:	7f 56                	jg     80103924 <piperead+0xc4>
801038ce:	eb 5c                	jmp    8010392c <piperead+0xcc>
801038d0:	eb 2e                	jmp    80103900 <piperead+0xa0>
801038d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038df:	00 
801038e0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038e7:	00 
801038e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038ef:	00 
801038f0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038f7:	00 
801038f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038ff:	00 
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103900:	8d 48 01             	lea    0x1(%eax),%ecx
80103903:	25 ff 01 00 00       	and    $0x1ff,%eax
80103908:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010390e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103913:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103916:	83 c3 01             	add    $0x1,%ebx
80103919:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010391c:	74 0e                	je     8010392c <piperead+0xcc>
8010391e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103924:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010392a:	75 d4                	jne    80103900 <piperead+0xa0>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010392c:	83 ec 0c             	sub    $0xc,%esp
8010392f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103935:	50                   	push   %eax
80103936:	e8 a5 0b 00 00       	call   801044e0 <wakeup>
  release(&p->lock);
8010393b:	89 34 24             	mov    %esi,(%esp)
8010393e:	e8 3d 10 00 00       	call   80104980 <release>
  return i;
80103943:	83 c4 10             	add    $0x10,%esp
}
80103946:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103949:	89 d8                	mov    %ebx,%eax
8010394b:	5b                   	pop    %ebx
8010394c:	5e                   	pop    %esi
8010394d:	5f                   	pop    %edi
8010394e:	5d                   	pop    %ebp
8010394f:	c3                   	ret
      release(&p->lock);
80103950:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103953:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103958:	56                   	push   %esi
80103959:	e8 22 10 00 00       	call   80104980 <release>
      return -1;
8010395e:	83 c4 10             	add    $0x10,%esp
}
80103961:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103964:	89 d8                	mov    %ebx,%eax
80103966:	5b                   	pop    %ebx
80103967:	5e                   	pop    %esi
80103968:	5f                   	pop    %edi
80103969:	5d                   	pop    %ebp
8010396a:	c3                   	ret
8010396b:	66 90                	xchg   %ax,%ax
8010396d:	66 90                	xchg   %ax,%ax
8010396f:	66 90                	xchg   %ax,%ax
80103971:	66 90                	xchg   %ax,%ax
80103973:	66 90                	xchg   %ax,%ax
80103975:	66 90                	xchg   %ax,%ax
80103977:	66 90                	xchg   %ax,%ax
80103979:	66 90                	xchg   %ax,%ax
8010397b:	66 90                	xchg   %ax,%ax
8010397d:	66 90                	xchg   %ax,%ax
8010397f:	90                   	nop

80103980 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103984:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103989:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010398c:	68 20 2d 11 80       	push   $0x80112d20
80103991:	e8 4a 10 00 00       	call   801049e0 <acquire>
80103996:	83 c4 10             	add    $0x10,%esp
80103999:	eb 17                	jmp    801039b2 <allocproc+0x32>
8010399b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039a0:	81 c3 84 00 00 00    	add    $0x84,%ebx
801039a6:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
801039ac:	0f 84 7e 00 00 00    	je     80103a30 <allocproc+0xb0>
    if(p->state == UNUSED)
801039b2:	8b 43 0c             	mov    0xc(%ebx),%eax
801039b5:	85 c0                	test   %eax,%eax
801039b7:	75 e7                	jne    801039a0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039b9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->tickets = 1;

  release(&ptable.lock);
801039be:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801039c1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->tickets = 1;
801039c8:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
  p->pid = nextpid++;
801039cf:	89 43 10             	mov    %eax,0x10(%ebx)
801039d2:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801039d5:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
801039da:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801039e0:	e8 9b 0f 00 00       	call   80104980 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039e5:	e8 a6 ed ff ff       	call   80102790 <kalloc>
801039ea:	83 c4 10             	add    $0x10,%esp
801039ed:	89 43 08             	mov    %eax,0x8(%ebx)
801039f0:	85 c0                	test   %eax,%eax
801039f2:	74 55                	je     80103a49 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039f4:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039fa:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801039fd:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103a02:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103a05:	c7 40 14 ff 5c 10 80 	movl   $0x80105cff,0x14(%eax)
  p->context = (struct context*)sp;
80103a0c:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a0f:	6a 14                	push   $0x14
80103a11:	6a 00                	push   $0x0
80103a13:	50                   	push   %eax
80103a14:	e8 e7 10 00 00       	call   80104b00 <memset>
  p->context->eip = (uint)forkret;
80103a19:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103a1c:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a1f:	c7 40 10 60 3a 10 80 	movl   $0x80103a60,0x10(%eax)
}
80103a26:	89 d8                	mov    %ebx,%eax
80103a28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a2b:	c9                   	leave
80103a2c:	c3                   	ret
80103a2d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103a30:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a33:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a35:	68 20 2d 11 80       	push   $0x80112d20
80103a3a:	e8 41 0f 00 00       	call   80104980 <release>
  return 0;
80103a3f:	83 c4 10             	add    $0x10,%esp
}
80103a42:	89 d8                	mov    %ebx,%eax
80103a44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a47:	c9                   	leave
80103a48:	c3                   	ret
    p->state = UNUSED;
80103a49:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80103a50:	31 db                	xor    %ebx,%ebx
80103a52:	eb ee                	jmp    80103a42 <allocproc+0xc2>
80103a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a5f:	00 

80103a60 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a66:	68 20 2d 11 80       	push   $0x80112d20
80103a6b:	e8 10 0f 00 00       	call   80104980 <release>

  if (first) {
80103a70:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a75:	83 c4 10             	add    $0x10,%esp
80103a78:	85 c0                	test   %eax,%eax
80103a7a:	75 04                	jne    80103a80 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a7c:	c9                   	leave
80103a7d:	c3                   	ret
80103a7e:	66 90                	xchg   %ax,%ax
    first = 0;
80103a80:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a87:	00 00 00 
    iinit(ROOTDEV);
80103a8a:	83 ec 0c             	sub    $0xc,%esp
80103a8d:	6a 01                	push   $0x1
80103a8f:	e8 ac db ff ff       	call   80101640 <iinit>
    initlog(ROOTDEV);
80103a94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a9b:	e8 90 f3 ff ff       	call   80102e30 <initlog>
}
80103aa0:	83 c4 10             	add    $0x10,%esp
80103aa3:	c9                   	leave
80103aa4:	c3                   	ret
80103aa5:	8d 76 00             	lea    0x0(%esi),%esi
80103aa8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103aaf:	00 

80103ab0 <randint>:
randint(int max) {
80103ab0:	55                   	push   %ebp
80103ab1:	31 d2                	xor    %edx,%edx
80103ab3:	89 e5                	mov    %esp,%ebp
80103ab5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if (max <= 0) return 0;
80103ab8:	85 c9                	test   %ecx,%ecx
80103aba:	7e 1d                	jle    80103ad9 <randint+0x29>
  seed = (seed * 1103515245 + 12345) & 0x7fffffff;
80103abc:	69 05 08 b0 10 80 6d 	imul   $0x41c64e6d,0x8010b008,%eax
80103ac3:	4e c6 41 
  return seed % max;
80103ac6:	31 d2                	xor    %edx,%edx
  seed = (seed * 1103515245 + 12345) & 0x7fffffff;
80103ac8:	05 39 30 00 00       	add    $0x3039,%eax
80103acd:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
80103ad2:	a3 08 b0 10 80       	mov    %eax,0x8010b008
  return seed % max;
80103ad7:	f7 f1                	div    %ecx
}
80103ad9:	89 d0                	mov    %edx,%eax
80103adb:	5d                   	pop    %ebp
80103adc:	c3                   	ret
80103add:	8d 76 00             	lea    0x0(%esi),%esi

80103ae0 <pinit>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103ae6:	68 36 79 10 80       	push   $0x80107936
80103aeb:	68 20 2d 11 80       	push   $0x80112d20
80103af0:	e8 cb 0c 00 00       	call   801047c0 <initlock>
}
80103af5:	83 c4 10             	add    $0x10,%esp
80103af8:	c9                   	leave
80103af9:	c3                   	ret
80103afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b00 <mycpu>:
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	56                   	push   %esi
80103b04:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b05:	9c                   	pushf
80103b06:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b07:	f6 c4 02             	test   $0x2,%ah
80103b0a:	75 65                	jne    80103b71 <mycpu+0x71>
  apicid = lapicid();
80103b0c:	e8 ef ee ff ff       	call   80102a00 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103b11:	8b 1d 84 27 11 80    	mov    0x80112784,%ebx
  apicid = lapicid();
80103b17:	89 c6                	mov    %eax,%esi
  for (i = 0; i < ncpu; ++i) {
80103b19:	85 db                	test   %ebx,%ebx
80103b1b:	7e 47                	jle    80103b64 <mycpu+0x64>
80103b1d:	31 d2                	xor    %edx,%edx
80103b1f:	eb 26                	jmp    80103b47 <mycpu+0x47>
80103b21:	eb 1d                	jmp    80103b40 <mycpu+0x40>
80103b23:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b2f:	00 
80103b30:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b37:	00 
80103b38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b3f:	00 
80103b40:	83 c2 01             	add    $0x1,%edx
80103b43:	39 da                	cmp    %ebx,%edx
80103b45:	74 1d                	je     80103b64 <mycpu+0x64>
    if (cpus[i].apicid == apicid)
80103b47:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103b4d:	0f b6 88 a0 27 11 80 	movzbl -0x7feed860(%eax),%ecx
80103b54:	39 f1                	cmp    %esi,%ecx
80103b56:	75 e8                	jne    80103b40 <mycpu+0x40>
}
80103b58:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103b5b:	05 a0 27 11 80       	add    $0x801127a0,%eax
}
80103b60:	5b                   	pop    %ebx
80103b61:	5e                   	pop    %esi
80103b62:	5d                   	pop    %ebp
80103b63:	c3                   	ret
  panic("unknown apicid\n");
80103b64:	83 ec 0c             	sub    $0xc,%esp
80103b67:	68 3d 79 10 80       	push   $0x8010793d
80103b6c:	e8 2f c8 ff ff       	call   801003a0 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b71:	83 ec 0c             	sub    $0xc,%esp
80103b74:	68 7c 7c 10 80       	push   $0x80107c7c
80103b79:	e8 22 c8 ff ff       	call   801003a0 <panic>
80103b7e:	66 90                	xchg   %ax,%ax

80103b80 <cpuid>:
cpuid() {
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b86:	e8 75 ff ff ff       	call   80103b00 <mycpu>
}
80103b8b:	c9                   	leave
  return mycpu()-cpus;
80103b8c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103b91:	c1 f8 04             	sar    $0x4,%eax
80103b94:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b9a:	c3                   	ret
80103b9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103ba0 <myproc>:
myproc(void) {
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	53                   	push   %ebx
80103ba4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ba7:	e8 d4 0c 00 00       	call   80104880 <pushcli>
  c = mycpu();
80103bac:	e8 4f ff ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80103bb1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bb7:	e8 14 0d 00 00       	call   801048d0 <popcli>
}
80103bbc:	89 d8                	mov    %ebx,%eax
80103bbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bc1:	c9                   	leave
80103bc2:	c3                   	ret
80103bc3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103bc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103bcf:	00 

80103bd0 <userinit>:
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	53                   	push   %ebx
80103bd4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103bd7:	e8 a4 fd ff ff       	call   80103980 <allocproc>
80103bdc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103bde:	a3 54 4e 11 80       	mov    %eax,0x80114e54
  if((p->pgdir = setupkvm()) == 0)
80103be3:	e8 b8 37 00 00       	call   801073a0 <setupkvm>
80103be8:	89 43 04             	mov    %eax,0x4(%ebx)
80103beb:	85 c0                	test   %eax,%eax
80103bed:	0f 84 bd 00 00 00    	je     80103cb0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103bf3:	83 ec 04             	sub    $0x4,%esp
80103bf6:	68 2c 00 00 00       	push   $0x2c
80103bfb:	68 60 b4 10 80       	push   $0x8010b460
80103c00:	50                   	push   %eax
80103c01:	e8 7a 34 00 00       	call   80107080 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103c06:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103c09:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c0f:	6a 4c                	push   $0x4c
80103c11:	6a 00                	push   $0x0
80103c13:	ff 73 18             	push   0x18(%ebx)
80103c16:	e8 e5 0e 00 00       	call   80104b00 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c1b:	8b 43 18             	mov    0x18(%ebx),%eax
80103c1e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c23:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c26:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c2b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c2f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c32:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c36:	8b 43 18             	mov    0x18(%ebx),%eax
80103c39:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c3d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c41:	8b 43 18             	mov    0x18(%ebx),%eax
80103c44:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c48:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c4c:	8b 43 18             	mov    0x18(%ebx),%eax
80103c4f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c56:	8b 43 18             	mov    0x18(%ebx),%eax
80103c59:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c60:	8b 43 18             	mov    0x18(%ebx),%eax
80103c63:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c6a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c6d:	6a 10                	push   $0x10
80103c6f:	68 66 79 10 80       	push   $0x80107966
80103c74:	50                   	push   %eax
80103c75:	e8 36 10 00 00       	call   80104cb0 <safestrcpy>
  p->cwd = namei("/");
80103c7a:	c7 04 24 6f 79 10 80 	movl   $0x8010796f,(%esp)
80103c81:	e8 0a e5 ff ff       	call   80102190 <namei>
80103c86:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c89:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c90:	e8 4b 0d 00 00       	call   801049e0 <acquire>
  p->state = RUNNABLE;
80103c95:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c9c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ca3:	e8 d8 0c 00 00       	call   80104980 <release>
}
80103ca8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cab:	83 c4 10             	add    $0x10,%esp
80103cae:	c9                   	leave
80103caf:	c3                   	ret
    panic("userinit: out of memory?");
80103cb0:	83 ec 0c             	sub    $0xc,%esp
80103cb3:	68 4d 79 10 80       	push   $0x8010794d
80103cb8:	e8 e3 c6 ff ff       	call   801003a0 <panic>
80103cbd:	8d 76 00             	lea    0x0(%esi),%esi

80103cc0 <growproc>:
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	53                   	push   %ebx
80103cc4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103cc7:	e8 b4 0b 00 00       	call   80104880 <pushcli>
  c = mycpu();
80103ccc:	e8 2f fe ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80103cd1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cd7:	e8 f4 0b 00 00       	call   801048d0 <popcli>
  if(n > 0){
80103cdc:	8b 55 08             	mov    0x8(%ebp),%edx
  sz = curproc->sz;
80103cdf:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103ce1:	85 d2                	test   %edx,%edx
80103ce3:	7f 1b                	jg     80103d00 <growproc+0x40>
  } else if(n < 0){
80103ce5:	75 39                	jne    80103d20 <growproc+0x60>
  switchuvm(curproc);
80103ce7:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103cea:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103cec:	53                   	push   %ebx
80103ced:	e8 7e 32 00 00       	call   80106f70 <switchuvm>
  return 0;
80103cf2:	83 c4 10             	add    $0x10,%esp
80103cf5:	31 c0                	xor    %eax,%eax
}
80103cf7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cfa:	c9                   	leave
80103cfb:	c3                   	ret
80103cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d00:	8b 55 08             	mov    0x8(%ebp),%edx
80103d03:	83 ec 04             	sub    $0x4,%esp
80103d06:	01 c2                	add    %eax,%edx
80103d08:	52                   	push   %edx
80103d09:	50                   	push   %eax
80103d0a:	ff 73 04             	push   0x4(%ebx)
80103d0d:	e8 be 34 00 00       	call   801071d0 <allocuvm>
80103d12:	83 c4 10             	add    $0x10,%esp
80103d15:	85 c0                	test   %eax,%eax
80103d17:	75 ce                	jne    80103ce7 <growproc+0x27>
      return -1;
80103d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d1e:	eb d7                	jmp    80103cf7 <growproc+0x37>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d20:	8b 55 08             	mov    0x8(%ebp),%edx
80103d23:	83 ec 04             	sub    $0x4,%esp
80103d26:	01 c2                	add    %eax,%edx
80103d28:	52                   	push   %edx
80103d29:	50                   	push   %eax
80103d2a:	ff 73 04             	push   0x4(%ebx)
80103d2d:	e8 be 35 00 00       	call   801072f0 <deallocuvm>
80103d32:	83 c4 10             	add    $0x10,%esp
80103d35:	85 c0                	test   %eax,%eax
80103d37:	75 ae                	jne    80103ce7 <growproc+0x27>
80103d39:	eb de                	jmp    80103d19 <growproc+0x59>
80103d3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103d40 <fork>:
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	57                   	push   %edi
80103d44:	56                   	push   %esi
80103d45:	53                   	push   %ebx
80103d46:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d49:	e8 32 0b 00 00       	call   80104880 <pushcli>
  c = mycpu();
80103d4e:	e8 ad fd ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80103d53:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d59:	e8 72 0b 00 00       	call   801048d0 <popcli>
  if((np = allocproc()) == 0){
80103d5e:	e8 1d fc ff ff       	call   80103980 <allocproc>
80103d63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d66:	85 c0                	test   %eax,%eax
80103d68:	0f 84 e6 00 00 00    	je     80103e54 <fork+0x114>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d6e:	83 ec 08             	sub    $0x8,%esp
80103d71:	ff 33                	push   (%ebx)
80103d73:	89 c7                	mov    %eax,%edi
80103d75:	ff 73 04             	push   0x4(%ebx)
80103d78:	e8 13 37 00 00       	call   80107490 <copyuvm>
80103d7d:	83 c4 10             	add    $0x10,%esp
80103d80:	89 47 04             	mov    %eax,0x4(%edi)
80103d83:	85 c0                	test   %eax,%eax
80103d85:	0f 84 aa 00 00 00    	je     80103e35 <fork+0xf5>
  np->sz = curproc->sz;
80103d8b:	8b 03                	mov    (%ebx),%eax
80103d8d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  *np->tf = *curproc->tf;
80103d90:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103d95:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
80103d97:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
80103d9a:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103d9d:	8b 73 18             	mov    0x18(%ebx),%esi
80103da0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103da2:	31 f6                	xor    %esi,%esi
  np->tickets = curproc->tickets;
80103da4:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103da7:	89 42 7c             	mov    %eax,0x7c(%edx)
  np->tf->eax = 0;
80103daa:	8b 42 18             	mov    0x18(%edx),%eax
80103dad:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103db8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103dbf:	00 
    if(curproc->ofile[i])
80103dc0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103dc4:	85 c0                	test   %eax,%eax
80103dc6:	74 13                	je     80103ddb <fork+0x9b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103dc8:	83 ec 0c             	sub    $0xc,%esp
80103dcb:	50                   	push   %eax
80103dcc:	e8 5f d1 ff ff       	call   80100f30 <filedup>
80103dd1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dd4:	83 c4 10             	add    $0x10,%esp
80103dd7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103ddb:	83 c6 01             	add    $0x1,%esi
80103dde:	83 fe 10             	cmp    $0x10,%esi
80103de1:	75 dd                	jne    80103dc0 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80103de3:	83 ec 0c             	sub    $0xc,%esp
80103de6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103de9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103dec:	e8 4f da ff ff       	call   80101840 <idup>
80103df1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103df4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103df7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dfa:	8d 47 6c             	lea    0x6c(%edi),%eax
80103dfd:	6a 10                	push   $0x10
80103dff:	53                   	push   %ebx
80103e00:	50                   	push   %eax
80103e01:	e8 aa 0e 00 00       	call   80104cb0 <safestrcpy>
  pid = np->pid;
80103e06:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103e09:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e10:	e8 cb 0b 00 00       	call   801049e0 <acquire>
  np->state = RUNNABLE;
80103e15:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103e1c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e23:	e8 58 0b 00 00       	call   80104980 <release>
  return pid;
80103e28:	83 c4 10             	add    $0x10,%esp
}
80103e2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e2e:	89 d8                	mov    %ebx,%eax
80103e30:	5b                   	pop    %ebx
80103e31:	5e                   	pop    %esi
80103e32:	5f                   	pop    %edi
80103e33:	5d                   	pop    %ebp
80103e34:	c3                   	ret
    kfree(np->kstack);
80103e35:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e38:	83 ec 0c             	sub    $0xc,%esp
80103e3b:	ff 73 08             	push   0x8(%ebx)
80103e3e:	e8 7d e7 ff ff       	call   801025c0 <kfree>
    np->kstack = 0;
80103e43:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103e4a:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103e4d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e54:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e59:	eb d0                	jmp    80103e2b <fork+0xeb>
80103e5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103e60 <scheduler>:
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	57                   	push   %edi
80103e64:	56                   	push   %esi
80103e65:	53                   	push   %ebx
80103e66:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103e69:	e8 92 fc ff ff       	call   80103b00 <mycpu>
  c->proc = 0;
80103e6e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e75:	00 00 00 
            cprintf("CPU %d: Winner PID %d (%d tix)\n", c - cpus, p->pid, p->tickets);
80103e78:	89 c6                	mov    %eax,%esi
  struct cpu *c = mycpu();
80103e7a:	89 c7                	mov    %eax,%edi
  c->proc = 0;
80103e7c:	8d 40 04             	lea    0x4(%eax),%eax
            cprintf("CPU %d: Winner PID %d (%d tix)\n", c - cpus, p->pid, p->tickets);
80103e7f:	81 ee a0 27 11 80    	sub    $0x801127a0,%esi
80103e85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103e88:	c1 fe 04             	sar    $0x4,%esi
80103e8b:	69 f6 a3 8b 2e ba    	imul   $0xba2e8ba3,%esi,%esi
80103e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e9f:	00 
  asm volatile("sti");
80103ea0:	fb                   	sti
    acquire(&ptable.lock);
80103ea1:	83 ec 0c             	sub    $0xc,%esp
80103ea4:	68 20 2d 11 80       	push   $0x80112d20
80103ea9:	e8 32 0b 00 00       	call   801049e0 <acquire>
80103eae:	83 c4 10             	add    $0x10,%esp
    int total_tickets = 0;
80103eb1:	31 c9                	xor    %ecx,%ecx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eb3:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103eb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ebf:	00 
      if(p->state == RUNNABLE)
80103ec0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103ec4:	75 03                	jne    80103ec9 <scheduler+0x69>
        total_tickets += p->tickets;
80103ec6:	03 48 7c             	add    0x7c(%eax),%ecx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ec9:	05 84 00 00 00       	add    $0x84,%eax
80103ece:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103ed3:	75 eb                	jne    80103ec0 <scheduler+0x60>
    if(total_tickets > 0){
80103ed5:	85 c9                	test   %ecx,%ecx
80103ed7:	0f 8e a3 00 00 00    	jle    80103f80 <scheduler+0x120>
  seed = (seed * 1103515245 + 12345) & 0x7fffffff;
80103edd:	69 05 08 b0 10 80 6d 	imul   $0x41c64e6d,0x8010b008,%eax
80103ee4:	4e c6 41 
  return seed % max;
80103ee7:	31 d2                	xor    %edx,%edx
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ee9:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  seed = (seed * 1103515245 + 12345) & 0x7fffffff;
80103eee:	05 39 30 00 00       	add    $0x3039,%eax
80103ef3:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
80103ef8:	a3 08 b0 10 80       	mov    %eax,0x8010b008
  return seed % max;
80103efd:	f7 f1                	div    %ecx
      int counter = 0;
80103eff:	31 c0                	xor    %eax,%eax
80103f01:	eb 2b                	jmp    80103f2e <scheduler+0xce>
80103f03:	eb 1b                	jmp    80103f20 <scheduler+0xc0>
80103f05:	8d 76 00             	lea    0x0(%esi),%esi
80103f08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f0f:	00 
80103f10:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f17:	00 
80103f18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f1f:	00 
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f20:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103f26:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
80103f2c:	74 52                	je     80103f80 <scheduler+0x120>
        if(p->state == RUNNABLE){
80103f2e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f32:	75 ec                	jne    80103f20 <scheduler+0xc0>
          counter += p->tickets;
80103f34:	8b 4b 7c             	mov    0x7c(%ebx),%ecx
80103f37:	01 c8                	add    %ecx,%eax
          if(counter > winner){
80103f39:	39 d0                	cmp    %edx,%eax
80103f3b:	7e e3                	jle    80103f20 <scheduler+0xc0>
            cprintf("CPU %d: Winner PID %d (%d tix)\n", c - cpus, p->pid, p->tickets);
80103f3d:	51                   	push   %ecx
80103f3e:	ff 73 10             	push   0x10(%ebx)
80103f41:	56                   	push   %esi
80103f42:	68 a4 7c 10 80       	push   $0x80107ca4
80103f47:	e8 84 c7 ff ff       	call   801006d0 <cprintf>
            c->proc = p;
80103f4c:	89 9f ac 00 00 00    	mov    %ebx,0xac(%edi)
            switchuvm(p);
80103f52:	89 1c 24             	mov    %ebx,(%esp)
80103f55:	e8 16 30 00 00       	call   80106f70 <switchuvm>
            swtch(&(c->scheduler), p->context);
80103f5a:	58                   	pop    %eax
80103f5b:	5a                   	pop    %edx
80103f5c:	ff 73 1c             	push   0x1c(%ebx)
80103f5f:	ff 75 e4             	push   -0x1c(%ebp)
            p->state = RUNNING;
80103f62:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
            swtch(&(c->scheduler), p->context);
80103f69:	e8 ad 0d 00 00       	call   80104d1b <swtch>
            switchkvm();
80103f6e:	e8 ed 2f 00 00       	call   80106f60 <switchkvm>
            break; 
80103f73:	83 c4 10             	add    $0x10,%esp
            c->proc = 0;
80103f76:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
80103f7d:	00 00 00 
    release(&ptable.lock);
80103f80:	83 ec 0c             	sub    $0xc,%esp
80103f83:	68 20 2d 11 80       	push   $0x80112d20
80103f88:	e8 f3 09 00 00       	call   80104980 <release>
  for(;;){
80103f8d:	83 c4 10             	add    $0x10,%esp
80103f90:	e9 0b ff ff ff       	jmp    80103ea0 <scheduler+0x40>
80103f95:	8d 76 00             	lea    0x0(%esi),%esi
80103f98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f9f:	00 

80103fa0 <sched>:
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	56                   	push   %esi
80103fa4:	53                   	push   %ebx
  pushcli();
80103fa5:	e8 d6 08 00 00       	call   80104880 <pushcli>
  c = mycpu();
80103faa:	e8 51 fb ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80103faf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fb5:	e8 16 09 00 00       	call   801048d0 <popcli>
  if(!holding(&ptable.lock))
80103fba:	83 ec 0c             	sub    $0xc,%esp
80103fbd:	68 20 2d 11 80       	push   $0x80112d20
80103fc2:	e8 69 09 00 00       	call   80104930 <holding>
80103fc7:	83 c4 10             	add    $0x10,%esp
80103fca:	85 c0                	test   %eax,%eax
80103fcc:	74 4f                	je     8010401d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103fce:	e8 2d fb ff ff       	call   80103b00 <mycpu>
80103fd3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103fda:	75 68                	jne    80104044 <sched+0xa4>
  if(p->state == RUNNING)
80103fdc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103fe0:	74 55                	je     80104037 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fe2:	9c                   	pushf
80103fe3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103fe4:	f6 c4 02             	test   $0x2,%ah
80103fe7:	75 41                	jne    8010402a <sched+0x8a>
  intena = mycpu()->intena;
80103fe9:	e8 12 fb ff ff       	call   80103b00 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103fee:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103ff1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ff7:	e8 04 fb ff ff       	call   80103b00 <mycpu>
80103ffc:	83 ec 08             	sub    $0x8,%esp
80103fff:	ff 70 04             	push   0x4(%eax)
80104002:	53                   	push   %ebx
80104003:	e8 13 0d 00 00       	call   80104d1b <swtch>
  mycpu()->intena = intena;
80104008:	e8 f3 fa ff ff       	call   80103b00 <mycpu>
}
8010400d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104010:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104016:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104019:	5b                   	pop    %ebx
8010401a:	5e                   	pop    %esi
8010401b:	5d                   	pop    %ebp
8010401c:	c3                   	ret
    panic("sched ptable.lock");
8010401d:	83 ec 0c             	sub    $0xc,%esp
80104020:	68 71 79 10 80       	push   $0x80107971
80104025:	e8 76 c3 ff ff       	call   801003a0 <panic>
    panic("sched interruptible");
8010402a:	83 ec 0c             	sub    $0xc,%esp
8010402d:	68 9d 79 10 80       	push   $0x8010799d
80104032:	e8 69 c3 ff ff       	call   801003a0 <panic>
    panic("sched running");
80104037:	83 ec 0c             	sub    $0xc,%esp
8010403a:	68 8f 79 10 80       	push   $0x8010798f
8010403f:	e8 5c c3 ff ff       	call   801003a0 <panic>
    panic("sched locks");
80104044:	83 ec 0c             	sub    $0xc,%esp
80104047:	68 83 79 10 80       	push   $0x80107983
8010404c:	e8 4f c3 ff ff       	call   801003a0 <panic>
80104051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104058:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010405f:	00 

80104060 <exit>:
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	57                   	push   %edi
80104064:	56                   	push   %esi
80104065:	53                   	push   %ebx
80104066:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104069:	e8 32 fb ff ff       	call   80103ba0 <myproc>
  if(curproc == initproc)
8010406e:	39 05 54 4e 11 80    	cmp    %eax,0x80114e54
80104074:	0f 84 3f 01 00 00    	je     801041b9 <exit+0x159>
8010407a:	89 c3                	mov    %eax,%ebx
8010407c:	8d 70 28             	lea    0x28(%eax),%esi
8010407f:	8d 78 68             	lea    0x68(%eax),%edi
80104082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104088:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010408f:	00 
    if(curproc->ofile[fd]){
80104090:	8b 06                	mov    (%esi),%eax
80104092:	85 c0                	test   %eax,%eax
80104094:	74 12                	je     801040a8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104096:	83 ec 0c             	sub    $0xc,%esp
80104099:	50                   	push   %eax
8010409a:	e8 e1 ce ff ff       	call   80100f80 <fileclose>
      curproc->ofile[fd] = 0;
8010409f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801040a5:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801040a8:	83 c6 04             	add    $0x4,%esi
801040ab:	39 f7                	cmp    %esi,%edi
801040ad:	75 e1                	jne    80104090 <exit+0x30>
  begin_op();
801040af:	e8 2c ee ff ff       	call   80102ee0 <begin_op>
  iput(curproc->cwd);
801040b4:	83 ec 0c             	sub    $0xc,%esp
801040b7:	ff 73 68             	push   0x68(%ebx)
801040ba:	e8 e1 d8 ff ff       	call   801019a0 <iput>
  end_op();
801040bf:	e8 8c ee ff ff       	call   80102f50 <end_op>
  curproc->cwd = 0;
801040c4:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801040cb:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801040d2:	e8 09 09 00 00       	call   801049e0 <acquire>
  wakeup1(curproc->parent);
801040d7:	8b 53 14             	mov    0x14(%ebx),%edx
801040da:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040dd:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801040e2:	eb 28                	jmp    8010410c <exit+0xac>
801040e4:	eb 1a                	jmp    80104100 <exit+0xa0>
801040e6:	66 90                	xchg   %ax,%ax
801040e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801040ef:	00 
801040f0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801040f7:	00 
801040f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801040ff:	00 
80104100:	05 84 00 00 00       	add    $0x84,%eax
80104105:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
8010410a:	74 1e                	je     8010412a <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
8010410c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104110:	75 ee                	jne    80104100 <exit+0xa0>
80104112:	3b 50 20             	cmp    0x20(%eax),%edx
80104115:	75 e9                	jne    80104100 <exit+0xa0>
      p->state = RUNNABLE;
80104117:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010411e:	05 84 00 00 00       	add    $0x84,%eax
80104123:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80104128:	75 e2                	jne    8010410c <exit+0xac>
      p->parent = initproc;
8010412a:	8b 0d 54 4e 11 80    	mov    0x80114e54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104130:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80104135:	eb 17                	jmp    8010414e <exit+0xee>
80104137:	90                   	nop
80104138:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010413f:	00 
80104140:	81 c2 84 00 00 00    	add    $0x84,%edx
80104146:	81 fa 54 4e 11 80    	cmp    $0x80114e54,%edx
8010414c:	74 52                	je     801041a0 <exit+0x140>
    if(p->parent == curproc){
8010414e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104151:	75 ed                	jne    80104140 <exit+0xe0>
      p->parent = initproc;
80104153:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104156:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
8010415a:	75 e4                	jne    80104140 <exit+0xe0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010415c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104161:	eb 29                	jmp    8010418c <exit+0x12c>
80104163:	eb 1b                	jmp    80104180 <exit+0x120>
80104165:	8d 76 00             	lea    0x0(%esi),%esi
80104168:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010416f:	00 
80104170:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104177:	00 
80104178:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010417f:	00 
80104180:	05 84 00 00 00       	add    $0x84,%eax
80104185:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
8010418a:	74 b4                	je     80104140 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan)
8010418c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104190:	75 ee                	jne    80104180 <exit+0x120>
80104192:	3b 48 20             	cmp    0x20(%eax),%ecx
80104195:	75 e9                	jne    80104180 <exit+0x120>
      p->state = RUNNABLE;
80104197:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010419e:	eb e0                	jmp    80104180 <exit+0x120>
  curproc->state = ZOMBIE;
801041a0:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801041a7:	e8 f4 fd ff ff       	call   80103fa0 <sched>
  panic("zombie exit");
801041ac:	83 ec 0c             	sub    $0xc,%esp
801041af:	68 be 79 10 80       	push   $0x801079be
801041b4:	e8 e7 c1 ff ff       	call   801003a0 <panic>
    panic("init exiting");
801041b9:	83 ec 0c             	sub    $0xc,%esp
801041bc:	68 b1 79 10 80       	push   $0x801079b1
801041c1:	e8 da c1 ff ff       	call   801003a0 <panic>
801041c6:	66 90                	xchg   %ax,%ax
801041c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801041cf:	00 

801041d0 <wait>:
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	56                   	push   %esi
801041d4:	53                   	push   %ebx
  pushcli();
801041d5:	e8 a6 06 00 00       	call   80104880 <pushcli>
  c = mycpu();
801041da:	e8 21 f9 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
801041df:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041e5:	e8 e6 06 00 00       	call   801048d0 <popcli>
  acquire(&ptable.lock);
801041ea:	83 ec 0c             	sub    $0xc,%esp
801041ed:	68 20 2d 11 80       	push   $0x80112d20
801041f2:	e8 e9 07 00 00       	call   801049e0 <acquire>
801041f7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801041fa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041fc:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104201:	eb 2b                	jmp    8010422e <wait+0x5e>
80104203:	eb 1b                	jmp    80104220 <wait+0x50>
80104205:	8d 76 00             	lea    0x0(%esi),%esi
80104208:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010420f:	00 
80104210:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104217:	00 
80104218:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010421f:	00 
80104220:	81 c3 84 00 00 00    	add    $0x84,%ebx
80104226:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
8010422c:	74 1e                	je     8010424c <wait+0x7c>
      if(p->parent != curproc)
8010422e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104231:	75 ed                	jne    80104220 <wait+0x50>
      if(p->state == ZOMBIE){
80104233:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104237:	74 6f                	je     801042a8 <wait+0xd8>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104239:	81 c3 84 00 00 00    	add    $0x84,%ebx
      havekids = 1;
8010423f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104244:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
8010424a:	75 e2                	jne    8010422e <wait+0x5e>
    if(!havekids || curproc->killed){
8010424c:	85 c0                	test   %eax,%eax
8010424e:	0f 84 aa 00 00 00    	je     801042fe <wait+0x12e>
80104254:	8b 46 24             	mov    0x24(%esi),%eax
80104257:	85 c0                	test   %eax,%eax
80104259:	0f 85 9f 00 00 00    	jne    801042fe <wait+0x12e>
  pushcli();
8010425f:	e8 1c 06 00 00       	call   80104880 <pushcli>
  c = mycpu();
80104264:	e8 97 f8 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80104269:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010426f:	e8 5c 06 00 00       	call   801048d0 <popcli>
  if(p == 0) panic("sleep");
80104274:	85 db                	test   %ebx,%ebx
80104276:	0f 84 99 00 00 00    	je     80104315 <wait+0x145>
  if(p->tickets < 100) {
8010427c:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010427f:	83 f8 63             	cmp    $0x63,%eax
80104282:	7f 06                	jg     8010428a <wait+0xba>
    p->tickets++;
80104284:	83 c0 01             	add    $0x1,%eax
80104287:	89 43 7c             	mov    %eax,0x7c(%ebx)
  p->chan = chan;
8010428a:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
8010428d:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104294:	e8 07 fd ff ff       	call   80103fa0 <sched>
  p->chan = 0;
80104299:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  for(;;){
801042a0:	e9 55 ff ff ff       	jmp    801041fa <wait+0x2a>
801042a5:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
801042a8:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801042ab:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801042ae:	ff 73 08             	push   0x8(%ebx)
801042b1:	e8 0a e3 ff ff       	call   801025c0 <kfree>
        p->kstack = 0;
801042b6:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801042bd:	5a                   	pop    %edx
801042be:	ff 73 04             	push   0x4(%ebx)
801042c1:	e8 5a 30 00 00       	call   80107320 <freevm>
        p->pid = 0;
801042c6:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801042cd:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801042d4:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801042d8:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801042df:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801042e6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801042ed:	e8 8e 06 00 00       	call   80104980 <release>
        return pid;
801042f2:	83 c4 10             	add    $0x10,%esp
}
801042f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042f8:	89 f0                	mov    %esi,%eax
801042fa:	5b                   	pop    %ebx
801042fb:	5e                   	pop    %esi
801042fc:	5d                   	pop    %ebp
801042fd:	c3                   	ret
      release(&ptable.lock);
801042fe:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104301:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104306:	68 20 2d 11 80       	push   $0x80112d20
8010430b:	e8 70 06 00 00       	call   80104980 <release>
      return -1;
80104310:	83 c4 10             	add    $0x10,%esp
80104313:	eb e0                	jmp    801042f5 <wait+0x125>
  if(p == 0) panic("sleep");
80104315:	83 ec 0c             	sub    $0xc,%esp
80104318:	68 ca 79 10 80       	push   $0x801079ca
8010431d:	e8 7e c0 ff ff       	call   801003a0 <panic>
80104322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104328:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010432f:	00 

80104330 <yield>:
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	53                   	push   %ebx
80104334:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock); 
80104337:	68 20 2d 11 80       	push   $0x80112d20
8010433c:	e8 9f 06 00 00       	call   801049e0 <acquire>
  pushcli();
80104341:	e8 3a 05 00 00       	call   80104880 <pushcli>
  c = mycpu();
80104346:	e8 b5 f7 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
8010434b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104351:	e8 7a 05 00 00       	call   801048d0 <popcli>
  if(myproc()->pushed == 0) {
80104356:	83 c4 10             	add    $0x10,%esp
80104359:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
8010435f:	85 c0                	test   %eax,%eax
80104361:	74 5d                	je     801043c0 <yield+0x90>
  pushcli();
80104363:	e8 18 05 00 00       	call   80104880 <pushcli>
  c = mycpu();
80104368:	e8 93 f7 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
8010436d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104373:	e8 58 05 00 00       	call   801048d0 <popcli>
  myproc()->pushed = 0; 
80104378:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
8010437f:	00 00 00 
  pushcli();
80104382:	e8 f9 04 00 00       	call   80104880 <pushcli>
  c = mycpu();
80104387:	e8 74 f7 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
8010438c:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104392:	e8 39 05 00 00       	call   801048d0 <popcli>
  myproc()->state = RUNNABLE;
80104397:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010439e:	e8 fd fb ff ff       	call   80103fa0 <sched>
  release(&ptable.lock);
801043a3:	83 ec 0c             	sub    $0xc,%esp
801043a6:	68 20 2d 11 80       	push   $0x80112d20
801043ab:	e8 d0 05 00 00       	call   80104980 <release>
}
801043b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043b3:	83 c4 10             	add    $0x10,%esp
801043b6:	c9                   	leave
801043b7:	c3                   	ret
801043b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801043bf:	00 
  pushcli();
801043c0:	e8 bb 04 00 00       	call   80104880 <pushcli>
  c = mycpu();
801043c5:	e8 36 f7 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
801043ca:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043d0:	e8 fb 04 00 00       	call   801048d0 <popcli>
    if(myproc()->tickets < 100) {
801043d5:	83 7b 7c 63          	cmpl   $0x63,0x7c(%ebx)
801043d9:	7f 88                	jg     80104363 <yield+0x33>
  pushcli();
801043db:	e8 a0 04 00 00       	call   80104880 <pushcli>
  c = mycpu();
801043e0:	e8 1b f7 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
801043e5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043eb:	e8 e0 04 00 00       	call   801048d0 <popcli>
      myproc()->tickets++;
801043f0:	83 43 7c 01          	addl   $0x1,0x7c(%ebx)
801043f4:	e9 6a ff ff ff       	jmp    80104363 <yield+0x33>
801043f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104400 <sleep>:
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	57                   	push   %edi
80104404:	56                   	push   %esi
80104405:	53                   	push   %ebx
80104406:	83 ec 0c             	sub    $0xc,%esp
80104409:	8b 7d 08             	mov    0x8(%ebp),%edi
8010440c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010440f:	e8 6c 04 00 00       	call   80104880 <pushcli>
  c = mycpu();
80104414:	e8 e7 f6 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80104419:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010441f:	e8 ac 04 00 00       	call   801048d0 <popcli>
  if(p == 0) panic("sleep");
80104424:	85 db                	test   %ebx,%ebx
80104426:	0f 84 9d 00 00 00    	je     801044c9 <sleep+0xc9>
  if(lk == 0) panic("sleep without lk");
8010442c:	85 f6                	test   %esi,%esi
8010442e:	0f 84 88 00 00 00    	je     801044bc <sleep+0xbc>
  if(p->tickets < 100) {
80104434:	8b 43 7c             	mov    0x7c(%ebx),%eax
80104437:	83 f8 63             	cmp    $0x63,%eax
8010443a:	7e 54                	jle    80104490 <sleep+0x90>
  if(lk != &ptable.lock){
8010443c:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80104442:	74 5a                	je     8010449e <sleep+0x9e>
    acquire(&ptable.lock);
80104444:	83 ec 0c             	sub    $0xc,%esp
80104447:	68 20 2d 11 80       	push   $0x80112d20
8010444c:	e8 8f 05 00 00       	call   801049e0 <acquire>
    release(lk);
80104451:	89 34 24             	mov    %esi,(%esp)
80104454:	e8 27 05 00 00       	call   80104980 <release>
  p->chan = chan;
80104459:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010445c:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104463:	e8 38 fb ff ff       	call   80103fa0 <sched>
  p->chan = 0;
80104468:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
8010446f:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104476:	e8 05 05 00 00       	call   80104980 <release>
    acquire(lk);
8010447b:	83 c4 10             	add    $0x10,%esp
8010447e:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104484:	5b                   	pop    %ebx
80104485:	5e                   	pop    %esi
80104486:	5f                   	pop    %edi
80104487:	5d                   	pop    %ebp
    acquire(lk);
80104488:	e9 53 05 00 00       	jmp    801049e0 <acquire>
8010448d:	8d 76 00             	lea    0x0(%esi),%esi
    p->tickets++;
80104490:	83 c0 01             	add    $0x1,%eax
80104493:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if(lk != &ptable.lock){
80104496:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
8010449c:	75 a6                	jne    80104444 <sleep+0x44>
  p->chan = chan;
8010449e:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801044a1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801044a8:	e8 f3 fa ff ff       	call   80103fa0 <sched>
  p->chan = 0;
801044ad:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801044b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044b7:	5b                   	pop    %ebx
801044b8:	5e                   	pop    %esi
801044b9:	5f                   	pop    %edi
801044ba:	5d                   	pop    %ebp
801044bb:	c3                   	ret
  if(lk == 0) panic("sleep without lk");
801044bc:	83 ec 0c             	sub    $0xc,%esp
801044bf:	68 d0 79 10 80       	push   $0x801079d0
801044c4:	e8 d7 be ff ff       	call   801003a0 <panic>
  if(p == 0) panic("sleep");
801044c9:	83 ec 0c             	sub    $0xc,%esp
801044cc:	68 ca 79 10 80       	push   $0x801079ca
801044d1:	e8 ca be ff ff       	call   801003a0 <panic>
801044d6:	66 90                	xchg   %ax,%ax
801044d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044df:	00 

801044e0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	53                   	push   %ebx
801044e4:	83 ec 10             	sub    $0x10,%esp
801044e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801044ea:	68 20 2d 11 80       	push   $0x80112d20
801044ef:	e8 ec 04 00 00       	call   801049e0 <acquire>
801044f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044f7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801044fc:	eb 0e                	jmp    8010450c <wakeup+0x2c>
801044fe:	66 90                	xchg   %ax,%ax
80104500:	05 84 00 00 00       	add    $0x84,%eax
80104505:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
8010450a:	74 1e                	je     8010452a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010450c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104510:	75 ee                	jne    80104500 <wakeup+0x20>
80104512:	3b 58 20             	cmp    0x20(%eax),%ebx
80104515:	75 e9                	jne    80104500 <wakeup+0x20>
      p->state = RUNNABLE;
80104517:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010451e:	05 84 00 00 00       	add    $0x84,%eax
80104523:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80104528:	75 e2                	jne    8010450c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010452a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104531:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104534:	c9                   	leave
  release(&ptable.lock);
80104535:	e9 46 04 00 00       	jmp    80104980 <release>
8010453a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104540 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	53                   	push   %ebx
80104544:	83 ec 10             	sub    $0x10,%esp
80104547:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010454a:	68 20 2d 11 80       	push   $0x80112d20
8010454f:	e8 8c 04 00 00       	call   801049e0 <acquire>
80104554:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104557:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010455c:	eb 0e                	jmp    8010456c <kill+0x2c>
8010455e:	66 90                	xchg   %ax,%ax
80104560:	05 84 00 00 00       	add    $0x84,%eax
80104565:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
8010456a:	74 34                	je     801045a0 <kill+0x60>
    if(p->pid == pid){
8010456c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010456f:	75 ef                	jne    80104560 <kill+0x20>
      p->killed = 1;
80104571:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104578:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010457c:	75 07                	jne    80104585 <kill+0x45>
        p->state = RUNNABLE;
8010457e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104585:	83 ec 0c             	sub    $0xc,%esp
80104588:	68 20 2d 11 80       	push   $0x80112d20
8010458d:	e8 ee 03 00 00       	call   80104980 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104592:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104595:	83 c4 10             	add    $0x10,%esp
80104598:	31 c0                	xor    %eax,%eax
}
8010459a:	c9                   	leave
8010459b:	c3                   	ret
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801045a0:	83 ec 0c             	sub    $0xc,%esp
801045a3:	68 20 2d 11 80       	push   $0x80112d20
801045a8:	e8 d3 03 00 00       	call   80104980 <release>
}
801045ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801045b0:	83 c4 10             	add    $0x10,%esp
801045b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045b8:	c9                   	leave
801045b9:	c3                   	ret
801045ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	57                   	push   %edi
801045c4:	56                   	push   %esi
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
801045c5:	8d 75 c0             	lea    -0x40(%ebp),%esi
{
801045c8:	53                   	push   %ebx
801045c9:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
801045ce:	83 ec 3c             	sub    $0x3c,%esp
801045d1:	eb 27                	jmp    801045fa <procdump+0x3a>
801045d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801045d8:	83 ec 0c             	sub    $0xc,%esp
801045db:	68 8f 7b 10 80       	push   $0x80107b8f
801045e0:	e8 eb c0 ff ff       	call   801006d0 <cprintf>
801045e5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045e8:	81 c3 84 00 00 00    	add    $0x84,%ebx
801045ee:	81 fb c0 4e 11 80    	cmp    $0x80114ec0,%ebx
801045f4:	0f 84 86 00 00 00    	je     80104680 <procdump+0xc0>
    if(p->state == UNUSED)
801045fa:	8b 43 a0             	mov    -0x60(%ebx),%eax
801045fd:	85 c0                	test   %eax,%eax
801045ff:	74 e7                	je     801045e8 <procdump+0x28>
      state = "???";
80104601:	ba e1 79 10 80       	mov    $0x801079e1,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104606:	83 f8 05             	cmp    $0x5,%eax
80104609:	77 11                	ja     8010461c <procdump+0x5c>
8010460b:	8b 14 85 c0 7f 10 80 	mov    -0x7fef8040(,%eax,4),%edx
      state = "???";
80104612:	b8 e1 79 10 80       	mov    $0x801079e1,%eax
80104617:	85 d2                	test   %edx,%edx
80104619:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010461c:	53                   	push   %ebx
8010461d:	52                   	push   %edx
8010461e:	ff 73 a4             	push   -0x5c(%ebx)
80104621:	68 e5 79 10 80       	push   $0x801079e5
80104626:	e8 a5 c0 ff ff       	call   801006d0 <cprintf>
    if(p->state == SLEEPING){
8010462b:	83 c4 10             	add    $0x10,%esp
8010462e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104632:	75 a4                	jne    801045d8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104634:	83 ec 08             	sub    $0x8,%esp
80104637:	89 f7                	mov    %esi,%edi
80104639:	56                   	push   %esi
8010463a:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010463d:	8b 40 0c             	mov    0xc(%eax),%eax
80104640:	83 c0 08             	add    $0x8,%eax
80104643:	50                   	push   %eax
80104644:	e8 97 01 00 00       	call   801047e0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104649:	83 c4 10             	add    $0x10,%esp
8010464c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104650:	8b 07                	mov    (%edi),%eax
80104652:	85 c0                	test   %eax,%eax
80104654:	74 82                	je     801045d8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104656:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104659:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010465c:	50                   	push   %eax
8010465d:	68 21 77 10 80       	push   $0x80107721
80104662:	e8 69 c0 ff ff       	call   801006d0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104667:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010466a:	83 c4 10             	add    $0x10,%esp
8010466d:	39 c7                	cmp    %eax,%edi
8010466f:	75 df                	jne    80104650 <procdump+0x90>
80104671:	e9 62 ff ff ff       	jmp    801045d8 <procdump+0x18>
80104676:	66 90                	xchg   %ax,%ax
80104678:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010467f:	00 
  }
}
80104680:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104683:	5b                   	pop    %ebx
80104684:	5e                   	pop    %esi
80104685:	5f                   	pop    %edi
80104686:	5d                   	pop    %ebp
80104687:	c3                   	ret
80104688:	66 90                	xchg   %ax,%ax
8010468a:	66 90                	xchg   %ax,%ax
8010468c:	66 90                	xchg   %ax,%ax
8010468e:	66 90                	xchg   %ax,%ax

80104690 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	53                   	push   %ebx
80104694:	83 ec 0c             	sub    $0xc,%esp
80104697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010469a:	68 18 7a 10 80       	push   $0x80107a18
8010469f:	8d 43 04             	lea    0x4(%ebx),%eax
801046a2:	50                   	push   %eax
801046a3:	e8 18 01 00 00       	call   801047c0 <initlock>
  lk->name = name;
801046a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801046ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801046b1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801046b4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801046bb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801046be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046c1:	c9                   	leave
801046c2:	c3                   	ret
801046c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801046c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801046cf:	00 

801046d0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	56                   	push   %esi
801046d4:	53                   	push   %ebx
801046d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801046d8:	8d 73 04             	lea    0x4(%ebx),%esi
801046db:	83 ec 0c             	sub    $0xc,%esp
801046de:	56                   	push   %esi
801046df:	e8 fc 02 00 00       	call   801049e0 <acquire>
  while (lk->locked) {
801046e4:	8b 13                	mov    (%ebx),%edx
801046e6:	83 c4 10             	add    $0x10,%esp
801046e9:	85 d2                	test   %edx,%edx
801046eb:	74 16                	je     80104703 <acquiresleep+0x33>
801046ed:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801046f0:	83 ec 08             	sub    $0x8,%esp
801046f3:	56                   	push   %esi
801046f4:	53                   	push   %ebx
801046f5:	e8 06 fd ff ff       	call   80104400 <sleep>
  while (lk->locked) {
801046fa:	8b 03                	mov    (%ebx),%eax
801046fc:	83 c4 10             	add    $0x10,%esp
801046ff:	85 c0                	test   %eax,%eax
80104701:	75 ed                	jne    801046f0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104703:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104709:	e8 92 f4 ff ff       	call   80103ba0 <myproc>
8010470e:	8b 40 10             	mov    0x10(%eax),%eax
80104711:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104714:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104717:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010471a:	5b                   	pop    %ebx
8010471b:	5e                   	pop    %esi
8010471c:	5d                   	pop    %ebp
  release(&lk->lk);
8010471d:	e9 5e 02 00 00       	jmp    80104980 <release>
80104722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104728:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010472f:	00 

80104730 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	56                   	push   %esi
80104734:	53                   	push   %ebx
80104735:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104738:	8d 73 04             	lea    0x4(%ebx),%esi
8010473b:	83 ec 0c             	sub    $0xc,%esp
8010473e:	56                   	push   %esi
8010473f:	e8 9c 02 00 00       	call   801049e0 <acquire>
  lk->locked = 0;
80104744:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010474a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104751:	89 1c 24             	mov    %ebx,(%esp)
80104754:	e8 87 fd ff ff       	call   801044e0 <wakeup>
  release(&lk->lk);
80104759:	83 c4 10             	add    $0x10,%esp
8010475c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010475f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104762:	5b                   	pop    %ebx
80104763:	5e                   	pop    %esi
80104764:	5d                   	pop    %ebp
  release(&lk->lk);
80104765:	e9 16 02 00 00       	jmp    80104980 <release>
8010476a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104770 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	57                   	push   %edi
80104774:	31 ff                	xor    %edi,%edi
80104776:	56                   	push   %esi
80104777:	53                   	push   %ebx
80104778:	83 ec 18             	sub    $0x18,%esp
8010477b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010477e:	8d 73 04             	lea    0x4(%ebx),%esi
80104781:	56                   	push   %esi
80104782:	e8 59 02 00 00       	call   801049e0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104787:	8b 03                	mov    (%ebx),%eax
80104789:	83 c4 10             	add    $0x10,%esp
8010478c:	85 c0                	test   %eax,%eax
8010478e:	75 18                	jne    801047a8 <holdingsleep+0x38>
  release(&lk->lk);
80104790:	83 ec 0c             	sub    $0xc,%esp
80104793:	56                   	push   %esi
80104794:	e8 e7 01 00 00       	call   80104980 <release>
  return r;
}
80104799:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010479c:	89 f8                	mov    %edi,%eax
8010479e:	5b                   	pop    %ebx
8010479f:	5e                   	pop    %esi
801047a0:	5f                   	pop    %edi
801047a1:	5d                   	pop    %ebp
801047a2:	c3                   	ret
801047a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
801047a8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801047ab:	e8 f0 f3 ff ff       	call   80103ba0 <myproc>
801047b0:	39 58 10             	cmp    %ebx,0x10(%eax)
801047b3:	0f 94 c0             	sete   %al
801047b6:	0f b6 c0             	movzbl %al,%eax
801047b9:	89 c7                	mov    %eax,%edi
801047bb:	eb d3                	jmp    80104790 <holdingsleep+0x20>
801047bd:	66 90                	xchg   %ax,%ax
801047bf:	90                   	nop

801047c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801047c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801047c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801047cf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801047d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801047d9:	5d                   	pop    %ebp
801047da:	c3                   	ret
801047db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801047e0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801047e0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801047e1:	31 d2                	xor    %edx,%edx
{
801047e3:	89 e5                	mov    %esp,%ebp
801047e5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801047e6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801047e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801047ec:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801047ef:	90                   	nop
801047f0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047f7:	00 
801047f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047ff:	00 
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104800:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104806:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010480c:	77 1a                	ja     80104828 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010480e:	8b 58 04             	mov    0x4(%eax),%ebx
80104811:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104814:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104817:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104819:	83 fa 0a             	cmp    $0xa,%edx
8010481c:	75 e2                	jne    80104800 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010481e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104821:	c9                   	leave
80104822:	c3                   	ret
80104823:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104828:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010482b:	83 c1 28             	add    $0x28,%ecx
8010482e:	89 ca                	mov    %ecx,%edx
80104830:	29 c2                	sub    %eax,%edx
80104832:	83 e2 04             	and    $0x4,%edx
80104835:	74 29                	je     80104860 <getcallerpcs+0x80>
    pcs[i] = 0;
80104837:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010483d:	83 c0 04             	add    $0x4,%eax
80104840:	39 c8                	cmp    %ecx,%eax
80104842:	74 da                	je     8010481e <getcallerpcs+0x3e>
80104844:	eb 1a                	jmp    80104860 <getcallerpcs+0x80>
80104846:	66 90                	xchg   %ax,%ax
80104848:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010484f:	00 
80104850:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104857:	00 
80104858:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010485f:	00 
    pcs[i] = 0;
80104860:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104866:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104869:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104870:	39 c8                	cmp    %ecx,%eax
80104872:	75 ec                	jne    80104860 <getcallerpcs+0x80>
80104874:	eb a8                	jmp    8010481e <getcallerpcs+0x3e>
80104876:	66 90                	xchg   %ax,%ax
80104878:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010487f:	00 

80104880 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	53                   	push   %ebx
80104884:	83 ec 04             	sub    $0x4,%esp
80104887:	9c                   	pushf
80104888:	5b                   	pop    %ebx
  asm volatile("cli");
80104889:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010488a:	e8 71 f2 ff ff       	call   80103b00 <mycpu>
8010488f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104895:	85 c0                	test   %eax,%eax
80104897:	74 17                	je     801048b0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104899:	e8 62 f2 ff ff       	call   80103b00 <mycpu>
8010489e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801048a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048a8:	c9                   	leave
801048a9:	c3                   	ret
801048aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801048b0:	e8 4b f2 ff ff       	call   80103b00 <mycpu>
801048b5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801048bb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801048c1:	eb d6                	jmp    80104899 <pushcli+0x19>
801048c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801048c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048cf:	00 

801048d0 <popcli>:

void
popcli(void)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801048d6:	9c                   	pushf
801048d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801048d8:	f6 c4 02             	test   $0x2,%ah
801048db:	75 35                	jne    80104912 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801048dd:	e8 1e f2 ff ff       	call   80103b00 <mycpu>
801048e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801048e9:	78 34                	js     8010491f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801048eb:	e8 10 f2 ff ff       	call   80103b00 <mycpu>
801048f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801048f6:	85 d2                	test   %edx,%edx
801048f8:	74 06                	je     80104900 <popcli+0x30>
    sti();
}
801048fa:	c9                   	leave
801048fb:	c3                   	ret
801048fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104900:	e8 fb f1 ff ff       	call   80103b00 <mycpu>
80104905:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010490b:	85 c0                	test   %eax,%eax
8010490d:	74 eb                	je     801048fa <popcli+0x2a>
  asm volatile("sti");
8010490f:	fb                   	sti
}
80104910:	c9                   	leave
80104911:	c3                   	ret
    panic("popcli - interruptible");
80104912:	83 ec 0c             	sub    $0xc,%esp
80104915:	68 23 7a 10 80       	push   $0x80107a23
8010491a:	e8 81 ba ff ff       	call   801003a0 <panic>
    panic("popcli");
8010491f:	83 ec 0c             	sub    $0xc,%esp
80104922:	68 3a 7a 10 80       	push   $0x80107a3a
80104927:	e8 74 ba ff ff       	call   801003a0 <panic>
8010492c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104930 <holding>:
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	53                   	push   %ebx
80104934:	31 db                	xor    %ebx,%ebx
80104936:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104939:	e8 42 ff ff ff       	call   80104880 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010493e:	8b 45 08             	mov    0x8(%ebp),%eax
80104941:	8b 10                	mov    (%eax),%edx
80104943:	85 d2                	test   %edx,%edx
80104945:	75 11                	jne    80104958 <holding+0x28>
  popcli();
80104947:	e8 84 ff ff ff       	call   801048d0 <popcli>
}
8010494c:	89 d8                	mov    %ebx,%eax
8010494e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104951:	c9                   	leave
80104952:	c3                   	ret
80104953:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104958:	8b 58 08             	mov    0x8(%eax),%ebx
8010495b:	e8 a0 f1 ff ff       	call   80103b00 <mycpu>
80104960:	39 c3                	cmp    %eax,%ebx
80104962:	0f 94 c3             	sete   %bl
  popcli();
80104965:	e8 66 ff ff ff       	call   801048d0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010496a:	0f b6 db             	movzbl %bl,%ebx
}
8010496d:	89 d8                	mov    %ebx,%eax
8010496f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104972:	c9                   	leave
80104973:	c3                   	ret
80104974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104978:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010497f:	00 

80104980 <release>:
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	53                   	push   %ebx
80104985:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104988:	e8 f3 fe ff ff       	call   80104880 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010498d:	8b 03                	mov    (%ebx),%eax
8010498f:	85 c0                	test   %eax,%eax
80104991:	75 15                	jne    801049a8 <release+0x28>
  popcli();
80104993:	e8 38 ff ff ff       	call   801048d0 <popcli>
    panic("release");
80104998:	83 ec 0c             	sub    $0xc,%esp
8010499b:	68 41 7a 10 80       	push   $0x80107a41
801049a0:	e8 fb b9 ff ff       	call   801003a0 <panic>
801049a5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801049a8:	8b 73 08             	mov    0x8(%ebx),%esi
801049ab:	e8 50 f1 ff ff       	call   80103b00 <mycpu>
801049b0:	39 c6                	cmp    %eax,%esi
801049b2:	75 df                	jne    80104993 <release+0x13>
  popcli();
801049b4:	e8 17 ff ff ff       	call   801048d0 <popcli>
  lk->pcs[0] = 0;
801049b9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801049c0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801049c7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801049cc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801049d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049d5:	5b                   	pop    %ebx
801049d6:	5e                   	pop    %esi
801049d7:	5d                   	pop    %ebp
  popcli();
801049d8:	e9 f3 fe ff ff       	jmp    801048d0 <popcli>
801049dd:	8d 76 00             	lea    0x0(%esi),%esi

801049e0 <acquire>:
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	56                   	push   %esi
801049e4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801049e5:	e8 96 fe ff ff       	call   80104880 <pushcli>
  if(holding(lk))
801049ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801049ed:	e8 8e fe ff ff       	call   80104880 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801049f2:	8b 03                	mov    (%ebx),%eax
801049f4:	85 c0                	test   %eax,%eax
801049f6:	0f 85 c4 00 00 00    	jne    80104ac0 <acquire+0xe0>
  popcli();
801049fc:	e8 cf fe ff ff       	call   801048d0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104a01:	b8 01 00 00 00       	mov    $0x1,%eax
80104a06:	f0 87 03             	lock xchg %eax,(%ebx)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104a09:	8b 55 08             	mov    0x8(%ebp),%edx
  while(xchg(&lk->locked, 1) != 0)
80104a0c:	85 c0                	test   %eax,%eax
80104a0e:	74 0c                	je     80104a1c <acquire+0x3c>
  asm volatile("lock; xchgl %0, %1" :
80104a10:	b8 01 00 00 00       	mov    $0x1,%eax
80104a15:	f0 87 02             	lock xchg %eax,(%edx)
80104a18:	85 c0                	test   %eax,%eax
80104a1a:	75 f4                	jne    80104a10 <acquire+0x30>
  __sync_synchronize();
80104a1c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104a21:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a24:	e8 d7 f0 ff ff       	call   80103b00 <mycpu>
  ebp = (uint*)v - 2;
80104a29:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104a2b:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104a2e:	31 c0                	xor    %eax,%eax
80104a30:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a37:	00 
80104a38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a3f:	00 
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a40:	8d 8a 00 00 00 80    	lea    -0x80000000(%edx),%ecx
80104a46:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104a4c:	77 22                	ja     80104a70 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104a4e:	8b 4a 04             	mov    0x4(%edx),%ecx
80104a51:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
  for(i = 0; i < 10; i++){
80104a55:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104a58:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104a5a:	83 f8 0a             	cmp    $0xa,%eax
80104a5d:	75 e1                	jne    80104a40 <acquire+0x60>
}
80104a5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a62:	5b                   	pop    %ebx
80104a63:	5e                   	pop    %esi
80104a64:	5d                   	pop    %ebp
80104a65:	c3                   	ret
80104a66:	66 90                	xchg   %ax,%ax
80104a68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a6f:	00 
  for(; i < 10; i++)
80104a70:	8d 44 83 0c          	lea    0xc(%ebx,%eax,4),%eax
80104a74:	83 c3 34             	add    $0x34,%ebx
80104a77:	89 da                	mov    %ebx,%edx
80104a79:	29 c2                	sub    %eax,%edx
80104a7b:	83 e2 04             	and    $0x4,%edx
80104a7e:	74 20                	je     80104aa0 <acquire+0xc0>
    pcs[i] = 0;
80104a80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104a86:	83 c0 04             	add    $0x4,%eax
80104a89:	39 d8                	cmp    %ebx,%eax
80104a8b:	74 d2                	je     80104a5f <acquire+0x7f>
80104a8d:	8d 76 00             	lea    0x0(%esi),%esi
80104a90:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a97:	00 
80104a98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a9f:	00 
    pcs[i] = 0;
80104aa0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104aa6:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104aa9:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104ab0:	39 d8                	cmp    %ebx,%eax
80104ab2:	75 ec                	jne    80104aa0 <acquire+0xc0>
80104ab4:	eb a9                	jmp    80104a5f <acquire+0x7f>
80104ab6:	66 90                	xchg   %ax,%ax
80104ab8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104abf:	00 
  r = lock->locked && lock->cpu == mycpu();
80104ac0:	8b 73 08             	mov    0x8(%ebx),%esi
80104ac3:	e8 38 f0 ff ff       	call   80103b00 <mycpu>
80104ac8:	39 c6                	cmp    %eax,%esi
80104aca:	0f 85 2c ff ff ff    	jne    801049fc <acquire+0x1c>
  popcli();
80104ad0:	e8 fb fd ff ff       	call   801048d0 <popcli>
    panic("acquire");
80104ad5:	83 ec 0c             	sub    $0xc,%esp
80104ad8:	68 49 7a 10 80       	push   $0x80107a49
80104add:	e8 be b8 ff ff       	call   801003a0 <panic>
80104ae2:	66 90                	xchg   %ax,%ax
80104ae4:	66 90                	xchg   %ax,%ax
80104ae6:	66 90                	xchg   %ax,%ax
80104ae8:	66 90                	xchg   %ax,%ax
80104aea:	66 90                	xchg   %ax,%ax
80104aec:	66 90                	xchg   %ax,%ax
80104aee:	66 90                	xchg   %ax,%ax
80104af0:	66 90                	xchg   %ax,%ax
80104af2:	66 90                	xchg   %ax,%ax
80104af4:	66 90                	xchg   %ax,%ax
80104af6:	66 90                	xchg   %ax,%ax
80104af8:	66 90                	xchg   %ax,%ax
80104afa:	66 90                	xchg   %ax,%ax
80104afc:	66 90                	xchg   %ax,%ax
80104afe:	66 90                	xchg   %ax,%ax

80104b00 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	57                   	push   %edi
80104b04:	8b 55 08             	mov    0x8(%ebp),%edx
80104b07:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104b0a:	89 d0                	mov    %edx,%eax
80104b0c:	09 c8                	or     %ecx,%eax
80104b0e:	a8 03                	test   $0x3,%al
80104b10:	75 1e                	jne    80104b30 <memset+0x30>
    c &= 0xFF;
80104b12:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104b16:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104b19:	89 d7                	mov    %edx,%edi
80104b1b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104b21:	fc                   	cld
80104b22:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104b24:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104b27:	89 d0                	mov    %edx,%eax
80104b29:	c9                   	leave
80104b2a:	c3                   	ret
80104b2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104b30:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b33:	89 d7                	mov    %edx,%edi
80104b35:	fc                   	cld
80104b36:	f3 aa                	rep stos %al,%es:(%edi)
80104b38:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104b3b:	89 d0                	mov    %edx,%eax
80104b3d:	c9                   	leave
80104b3e:	c3                   	ret
80104b3f:	90                   	nop

80104b40 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	56                   	push   %esi
80104b44:	8b 75 10             	mov    0x10(%ebp),%esi
80104b47:	8b 45 08             	mov    0x8(%ebp),%eax
80104b4a:	53                   	push   %ebx
80104b4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104b4e:	85 f6                	test   %esi,%esi
80104b50:	74 2e                	je     80104b80 <memcmp+0x40>
80104b52:	01 c6                	add    %eax,%esi
80104b54:	eb 14                	jmp    80104b6a <memcmp+0x2a>
80104b56:	66 90                	xchg   %ax,%ax
80104b58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b5f:	00 
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104b60:	83 c0 01             	add    $0x1,%eax
80104b63:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104b66:	39 f0                	cmp    %esi,%eax
80104b68:	74 16                	je     80104b80 <memcmp+0x40>
    if(*s1 != *s2)
80104b6a:	0f b6 08             	movzbl (%eax),%ecx
80104b6d:	0f b6 1a             	movzbl (%edx),%ebx
80104b70:	38 d9                	cmp    %bl,%cl
80104b72:	74 ec                	je     80104b60 <memcmp+0x20>
      return *s1 - *s2;
80104b74:	0f b6 c1             	movzbl %cl,%eax
80104b77:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104b79:	5b                   	pop    %ebx
80104b7a:	5e                   	pop    %esi
80104b7b:	5d                   	pop    %ebp
80104b7c:	c3                   	ret
80104b7d:	8d 76 00             	lea    0x0(%esi),%esi
80104b80:	5b                   	pop    %ebx
  return 0;
80104b81:	31 c0                	xor    %eax,%eax
}
80104b83:	5e                   	pop    %esi
80104b84:	5d                   	pop    %ebp
80104b85:	c3                   	ret
80104b86:	66 90                	xchg   %ax,%ax
80104b88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b8f:	00 

80104b90 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	57                   	push   %edi
80104b94:	8b 55 08             	mov    0x8(%ebp),%edx
80104b97:	8b 45 10             	mov    0x10(%ebp),%eax
80104b9a:	56                   	push   %esi
80104b9b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104b9e:	39 d6                	cmp    %edx,%esi
80104ba0:	73 26                	jae    80104bc8 <memmove+0x38>
80104ba2:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104ba5:	39 ca                	cmp    %ecx,%edx
80104ba7:	73 1f                	jae    80104bc8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104ba9:	85 c0                	test   %eax,%eax
80104bab:	74 0f                	je     80104bbc <memmove+0x2c>
80104bad:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104bb0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104bb4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104bb7:	83 e8 01             	sub    $0x1,%eax
80104bba:	73 f4                	jae    80104bb0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104bbc:	5e                   	pop    %esi
80104bbd:	89 d0                	mov    %edx,%eax
80104bbf:	5f                   	pop    %edi
80104bc0:	5d                   	pop    %ebp
80104bc1:	c3                   	ret
80104bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104bc8:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104bcb:	89 d7                	mov    %edx,%edi
80104bcd:	85 c0                	test   %eax,%eax
80104bcf:	74 eb                	je     80104bbc <memmove+0x2c>
80104bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bdf:	00 
      *d++ = *s++;
80104be0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104be1:	39 f1                	cmp    %esi,%ecx
80104be3:	75 fb                	jne    80104be0 <memmove+0x50>
}
80104be5:	5e                   	pop    %esi
80104be6:	89 d0                	mov    %edx,%eax
80104be8:	5f                   	pop    %edi
80104be9:	5d                   	pop    %ebp
80104bea:	c3                   	ret
80104beb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104bf0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104bf0:	eb 9e                	jmp    80104b90 <memmove>
80104bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bf8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bff:	00 

80104c00 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	53                   	push   %ebx
80104c04:	8b 55 10             	mov    0x10(%ebp),%edx
80104c07:	8b 45 08             	mov    0x8(%ebp),%eax
80104c0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
80104c0d:	85 d2                	test   %edx,%edx
80104c0f:	75 16                	jne    80104c27 <strncmp+0x27>
80104c11:	eb 2d                	jmp    80104c40 <strncmp+0x40>
80104c13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c18:	3a 19                	cmp    (%ecx),%bl
80104c1a:	75 12                	jne    80104c2e <strncmp+0x2e>
    n--, p++, q++;
80104c1c:	83 c0 01             	add    $0x1,%eax
80104c1f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104c22:	83 ea 01             	sub    $0x1,%edx
80104c25:	74 19                	je     80104c40 <strncmp+0x40>
80104c27:	0f b6 18             	movzbl (%eax),%ebx
80104c2a:	84 db                	test   %bl,%bl
80104c2c:	75 ea                	jne    80104c18 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104c2e:	0f b6 00             	movzbl (%eax),%eax
80104c31:	0f b6 11             	movzbl (%ecx),%edx
}
80104c34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c37:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104c38:	29 d0                	sub    %edx,%eax
}
80104c3a:	c3                   	ret
80104c3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104c43:	31 c0                	xor    %eax,%eax
}
80104c45:	c9                   	leave
80104c46:	c3                   	ret
80104c47:	90                   	nop
80104c48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c4f:	00 

80104c50 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	53                   	push   %ebx
80104c54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104c57:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104c5a:	8b 45 08             	mov    0x8(%ebp),%eax
80104c5d:	eb 14                	jmp    80104c73 <strncpy+0x23>
80104c5f:	90                   	nop
80104c60:	0f b6 19             	movzbl (%ecx),%ebx
80104c63:	83 c1 01             	add    $0x1,%ecx
80104c66:	83 c0 01             	add    $0x1,%eax
80104c69:	88 58 ff             	mov    %bl,-0x1(%eax)
80104c6c:	84 db                	test   %bl,%bl
80104c6e:	74 10                	je     80104c80 <strncpy+0x30>
80104c70:	83 ea 01             	sub    $0x1,%edx
80104c73:	85 d2                	test   %edx,%edx
80104c75:	7f e9                	jg     80104c60 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80104c77:	8b 45 08             	mov    0x8(%ebp),%eax
80104c7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c7d:	c9                   	leave
80104c7e:	c3                   	ret
80104c7f:	90                   	nop
  while(n-- > 0)
80104c80:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
80104c84:	83 ea 01             	sub    $0x1,%edx
80104c87:	74 ee                	je     80104c77 <strncpy+0x27>
80104c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104c90:	83 c0 01             	add    $0x1,%eax
80104c93:	89 ca                	mov    %ecx,%edx
80104c95:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104c99:	29 c2                	sub    %eax,%edx
80104c9b:	85 d2                	test   %edx,%edx
80104c9d:	7f f1                	jg     80104c90 <strncpy+0x40>
}
80104c9f:	8b 45 08             	mov    0x8(%ebp),%eax
80104ca2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ca5:	c9                   	leave
80104ca6:	c3                   	ret
80104ca7:	90                   	nop
80104ca8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104caf:	00 

80104cb0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	53                   	push   %ebx
80104cb4:	8b 55 10             	mov    0x10(%ebp),%edx
80104cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104cba:	85 d2                	test   %edx,%edx
80104cbc:	7e 39                	jle    80104cf7 <safestrcpy+0x47>
80104cbe:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104cc2:	8b 55 08             	mov    0x8(%ebp),%edx
80104cc5:	eb 29                	jmp    80104cf0 <safestrcpy+0x40>
80104cc7:	eb 17                	jmp    80104ce0 <safestrcpy+0x30>
80104cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cd0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104cd7:	00 
80104cd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104cdf:	00 
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ce0:	0f b6 08             	movzbl (%eax),%ecx
80104ce3:	83 c0 01             	add    $0x1,%eax
80104ce6:	83 c2 01             	add    $0x1,%edx
80104ce9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104cec:	84 c9                	test   %cl,%cl
80104cee:	74 04                	je     80104cf4 <safestrcpy+0x44>
80104cf0:	39 d8                	cmp    %ebx,%eax
80104cf2:	75 ec                	jne    80104ce0 <safestrcpy+0x30>
    ;
  *s = 0;
80104cf4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104cf7:	8b 45 08             	mov    0x8(%ebp),%eax
80104cfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cfd:	c9                   	leave
80104cfe:	c3                   	ret
80104cff:	90                   	nop

80104d00 <strlen>:

int
strlen(const char *s)
{
80104d00:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104d01:	31 c0                	xor    %eax,%eax
{
80104d03:	89 e5                	mov    %esp,%ebp
80104d05:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104d08:	80 3a 00             	cmpb   $0x0,(%edx)
80104d0b:	74 0c                	je     80104d19 <strlen+0x19>
80104d0d:	8d 76 00             	lea    0x0(%esi),%esi
80104d10:	83 c0 01             	add    $0x1,%eax
80104d13:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104d17:	75 f7                	jne    80104d10 <strlen+0x10>
    ;
  return n;
}
80104d19:	5d                   	pop    %ebp
80104d1a:	c3                   	ret

80104d1b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104d1b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104d1f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104d23:	55                   	push   %ebp
  pushl %ebx
80104d24:	53                   	push   %ebx
  pushl %esi
80104d25:	56                   	push   %esi
  pushl %edi
80104d26:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104d27:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104d29:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104d2b:	5f                   	pop    %edi
  popl %esi
80104d2c:	5e                   	pop    %esi
  popl %ebx
80104d2d:	5b                   	pop    %ebx
  popl %ebp
80104d2e:	5d                   	pop    %ebp
  ret
80104d2f:	c3                   	ret

80104d30 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	53                   	push   %ebx
80104d34:	83 ec 04             	sub    $0x4,%esp
80104d37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104d3a:	e8 61 ee ff ff       	call   80103ba0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d3f:	8b 00                	mov    (%eax),%eax
80104d41:	39 c3                	cmp    %eax,%ebx
80104d43:	73 1b                	jae    80104d60 <fetchint+0x30>
80104d45:	8d 53 04             	lea    0x4(%ebx),%edx
80104d48:	39 d0                	cmp    %edx,%eax
80104d4a:	72 14                	jb     80104d60 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d4f:	8b 13                	mov    (%ebx),%edx
80104d51:	89 10                	mov    %edx,(%eax)
  return 0;
80104d53:	31 c0                	xor    %eax,%eax
}
80104d55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d58:	c9                   	leave
80104d59:	c3                   	ret
80104d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d65:	eb ee                	jmp    80104d55 <fetchint+0x25>
80104d67:	90                   	nop
80104d68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d6f:	00 

80104d70 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	53                   	push   %ebx
80104d74:	83 ec 04             	sub    $0x4,%esp
80104d77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104d7a:	e8 21 ee ff ff       	call   80103ba0 <myproc>

  if(addr >= curproc->sz)
80104d7f:	3b 18                	cmp    (%eax),%ebx
80104d81:	73 35                	jae    80104db8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104d83:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d86:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104d88:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104d8a:	39 d3                	cmp    %edx,%ebx
80104d8c:	73 2a                	jae    80104db8 <fetchstr+0x48>
80104d8e:	89 d8                	mov    %ebx,%eax
80104d90:	eb 15                	jmp    80104da7 <fetchstr+0x37>
80104d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d9f:	00 
80104da0:	83 c0 01             	add    $0x1,%eax
80104da3:	39 d0                	cmp    %edx,%eax
80104da5:	73 11                	jae    80104db8 <fetchstr+0x48>
    if(*s == 0)
80104da7:	80 38 00             	cmpb   $0x0,(%eax)
80104daa:	75 f4                	jne    80104da0 <fetchstr+0x30>
      return s - *pp;
80104dac:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104dae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104db1:	c9                   	leave
80104db2:	c3                   	ret
80104db3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104db8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104dbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dc0:	c9                   	leave
80104dc1:	c3                   	ret
80104dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104dc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104dcf:	00 

80104dd0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	56                   	push   %esi
80104dd4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104dd5:	e8 c6 ed ff ff       	call   80103ba0 <myproc>
80104dda:	8b 55 08             	mov    0x8(%ebp),%edx
80104ddd:	8b 40 18             	mov    0x18(%eax),%eax
80104de0:	8b 40 44             	mov    0x44(%eax),%eax
80104de3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104de6:	e8 b5 ed ff ff       	call   80103ba0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104deb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dee:	8b 00                	mov    (%eax),%eax
80104df0:	39 c6                	cmp    %eax,%esi
80104df2:	73 1c                	jae    80104e10 <argint+0x40>
80104df4:	8d 53 08             	lea    0x8(%ebx),%edx
80104df7:	39 d0                	cmp    %edx,%eax
80104df9:	72 15                	jb     80104e10 <argint+0x40>
  *ip = *(int*)(addr);
80104dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dfe:	8b 53 04             	mov    0x4(%ebx),%edx
80104e01:	89 10                	mov    %edx,(%eax)
  return 0;
80104e03:	31 c0                	xor    %eax,%eax
}
80104e05:	5b                   	pop    %ebx
80104e06:	5e                   	pop    %esi
80104e07:	5d                   	pop    %ebp
80104e08:	c3                   	ret
80104e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e15:	eb ee                	jmp    80104e05 <argint+0x35>
80104e17:	90                   	nop
80104e18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e1f:	00 

80104e20 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	57                   	push   %edi
80104e24:	56                   	push   %esi
80104e25:	53                   	push   %ebx
80104e26:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104e29:	e8 72 ed ff ff       	call   80103ba0 <myproc>
80104e2e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e30:	e8 6b ed ff ff       	call   80103ba0 <myproc>
80104e35:	8b 55 08             	mov    0x8(%ebp),%edx
80104e38:	8b 40 18             	mov    0x18(%eax),%eax
80104e3b:	8b 40 44             	mov    0x44(%eax),%eax
80104e3e:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  struct proc *curproc = myproc();
80104e41:	e8 5a ed ff ff       	call   80103ba0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e46:	8d 5f 04             	lea    0x4(%edi),%ebx
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e49:	8b 00                	mov    (%eax),%eax
80104e4b:	39 c3                	cmp    %eax,%ebx
80104e4d:	73 31                	jae    80104e80 <argptr+0x60>
80104e4f:	8d 57 08             	lea    0x8(%edi),%edx
80104e52:	39 d0                	cmp    %edx,%eax
80104e54:	72 2a                	jb     80104e80 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104e56:	8b 45 10             	mov    0x10(%ebp),%eax
80104e59:	85 c0                	test   %eax,%eax
80104e5b:	78 23                	js     80104e80 <argptr+0x60>
  *ip = *(int*)(addr);
80104e5d:	8b 57 04             	mov    0x4(%edi),%edx
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104e60:	8b 0e                	mov    (%esi),%ecx
80104e62:	39 ca                	cmp    %ecx,%edx
80104e64:	73 1a                	jae    80104e80 <argptr+0x60>
80104e66:	8b 45 10             	mov    0x10(%ebp),%eax
80104e69:	01 d0                	add    %edx,%eax
80104e6b:	39 c1                	cmp    %eax,%ecx
80104e6d:	72 11                	jb     80104e80 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e72:	89 10                	mov    %edx,(%eax)
  return 0;
80104e74:	31 c0                	xor    %eax,%eax
}
80104e76:	83 c4 0c             	add    $0xc,%esp
80104e79:	5b                   	pop    %ebx
80104e7a:	5e                   	pop    %esi
80104e7b:	5f                   	pop    %edi
80104e7c:	5d                   	pop    %ebp
80104e7d:	c3                   	ret
80104e7e:	66 90                	xchg   %ax,%ax
    return -1;
80104e80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e85:	eb ef                	jmp    80104e76 <argptr+0x56>
80104e87:	90                   	nop
80104e88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e8f:	00 

80104e90 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	56                   	push   %esi
80104e94:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e95:	e8 06 ed ff ff       	call   80103ba0 <myproc>
80104e9a:	8b 55 08             	mov    0x8(%ebp),%edx
80104e9d:	8b 40 18             	mov    0x18(%eax),%eax
80104ea0:	8b 40 44             	mov    0x44(%eax),%eax
80104ea3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ea6:	e8 f5 ec ff ff       	call   80103ba0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104eab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104eae:	8b 00                	mov    (%eax),%eax
80104eb0:	39 c6                	cmp    %eax,%esi
80104eb2:	73 44                	jae    80104ef8 <argstr+0x68>
80104eb4:	8d 53 08             	lea    0x8(%ebx),%edx
80104eb7:	39 d0                	cmp    %edx,%eax
80104eb9:	72 3d                	jb     80104ef8 <argstr+0x68>
  *ip = *(int*)(addr);
80104ebb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104ebe:	e8 dd ec ff ff       	call   80103ba0 <myproc>
  if(addr >= curproc->sz)
80104ec3:	3b 18                	cmp    (%eax),%ebx
80104ec5:	73 31                	jae    80104ef8 <argstr+0x68>
  *pp = (char*)addr;
80104ec7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104eca:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104ecc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104ece:	39 d3                	cmp    %edx,%ebx
80104ed0:	73 26                	jae    80104ef8 <argstr+0x68>
80104ed2:	89 d8                	mov    %ebx,%eax
80104ed4:	eb 11                	jmp    80104ee7 <argstr+0x57>
80104ed6:	66 90                	xchg   %ax,%ax
80104ed8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104edf:	00 
80104ee0:	83 c0 01             	add    $0x1,%eax
80104ee3:	39 d0                	cmp    %edx,%eax
80104ee5:	73 11                	jae    80104ef8 <argstr+0x68>
    if(*s == 0)
80104ee7:	80 38 00             	cmpb   $0x0,(%eax)
80104eea:	75 f4                	jne    80104ee0 <argstr+0x50>
      return s - *pp;
80104eec:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104eee:	5b                   	pop    %ebx
80104eef:	5e                   	pop    %esi
80104ef0:	5d                   	pop    %ebp
80104ef1:	c3                   	ret
80104ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ef8:	5b                   	pop    %ebx
    return -1;
80104ef9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104efe:	5e                   	pop    %esi
80104eff:	5d                   	pop    %ebp
80104f00:	c3                   	ret
80104f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f0f:	00 

80104f10 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	53                   	push   %ebx
80104f14:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104f17:	e8 84 ec ff ff       	call   80103ba0 <myproc>
80104f1c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104f1e:	8b 40 18             	mov    0x18(%eax),%eax
80104f21:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f24:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f27:	83 fa 14             	cmp    $0x14,%edx
80104f2a:	77 24                	ja     80104f50 <syscall+0x40>
80104f2c:	8b 14 85 e0 7f 10 80 	mov    -0x7fef8020(,%eax,4),%edx
80104f33:	85 d2                	test   %edx,%edx
80104f35:	74 19                	je     80104f50 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104f37:	ff d2                	call   *%edx
80104f39:	89 c2                	mov    %eax,%edx
80104f3b:	8b 43 18             	mov    0x18(%ebx),%eax
80104f3e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104f41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f44:	c9                   	leave
80104f45:	c3                   	ret
80104f46:	66 90                	xchg   %ax,%ax
80104f48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f4f:	00 
    cprintf("%d %s: unknown sys call %d\n",
80104f50:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104f51:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104f54:	50                   	push   %eax
80104f55:	ff 73 10             	push   0x10(%ebx)
80104f58:	68 51 7a 10 80       	push   $0x80107a51
80104f5d:	e8 6e b7 ff ff       	call   801006d0 <cprintf>
    curproc->tf->eax = -1;
80104f62:	8b 43 18             	mov    0x18(%ebx),%eax
80104f65:	83 c4 10             	add    $0x10,%esp
80104f68:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104f6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f72:	c9                   	leave
80104f73:	c3                   	ret
80104f74:	66 90                	xchg   %ax,%ax
80104f76:	66 90                	xchg   %ax,%ax
80104f78:	66 90                	xchg   %ax,%ax
80104f7a:	66 90                	xchg   %ax,%ax
80104f7c:	66 90                	xchg   %ax,%ax
80104f7e:	66 90                	xchg   %ax,%ax

80104f80 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	57                   	push   %edi
80104f84:	56                   	push   %esi
80104f85:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104f86:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
80104f89:	83 ec 34             	sub    $0x34,%esp
80104f8c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
80104f8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f92:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104f95:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104f98:	53                   	push   %ebx
80104f99:	50                   	push   %eax
80104f9a:	e8 11 d2 ff ff       	call   801021b0 <nameiparent>
80104f9f:	83 c4 10             	add    $0x10,%esp
80104fa2:	85 c0                	test   %eax,%eax
80104fa4:	74 5e                	je     80105004 <create+0x84>
    return 0;
  ilock(dp);
80104fa6:	83 ec 0c             	sub    $0xc,%esp
80104fa9:	89 c6                	mov    %eax,%esi
80104fab:	50                   	push   %eax
80104fac:	e8 bf c8 ff ff       	call   80101870 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104fb1:	83 c4 0c             	add    $0xc,%esp
80104fb4:	6a 00                	push   $0x0
80104fb6:	53                   	push   %ebx
80104fb7:	56                   	push   %esi
80104fb8:	e8 13 ce ff ff       	call   80101dd0 <dirlookup>
80104fbd:	83 c4 10             	add    $0x10,%esp
80104fc0:	89 c7                	mov    %eax,%edi
80104fc2:	85 c0                	test   %eax,%eax
80104fc4:	74 4a                	je     80105010 <create+0x90>
    iunlockput(dp);
80104fc6:	83 ec 0c             	sub    $0xc,%esp
80104fc9:	56                   	push   %esi
80104fca:	e8 41 cb ff ff       	call   80101b10 <iunlockput>
    ilock(ip);
80104fcf:	89 3c 24             	mov    %edi,(%esp)
80104fd2:	e8 99 c8 ff ff       	call   80101870 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104fd7:	83 c4 10             	add    $0x10,%esp
80104fda:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104fdf:	75 17                	jne    80104ff8 <create+0x78>
80104fe1:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104fe6:	75 10                	jne    80104ff8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104fe8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104feb:	89 f8                	mov    %edi,%eax
80104fed:	5b                   	pop    %ebx
80104fee:	5e                   	pop    %esi
80104fef:	5f                   	pop    %edi
80104ff0:	5d                   	pop    %ebp
80104ff1:	c3                   	ret
80104ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104ff8:	83 ec 0c             	sub    $0xc,%esp
80104ffb:	57                   	push   %edi
80104ffc:	e8 0f cb ff ff       	call   80101b10 <iunlockput>
    return 0;
80105001:	83 c4 10             	add    $0x10,%esp
}
80105004:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105007:	31 ff                	xor    %edi,%edi
}
80105009:	5b                   	pop    %ebx
8010500a:	89 f8                	mov    %edi,%eax
8010500c:	5e                   	pop    %esi
8010500d:	5f                   	pop    %edi
8010500e:	5d                   	pop    %ebp
8010500f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80105010:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105014:	83 ec 08             	sub    $0x8,%esp
80105017:	50                   	push   %eax
80105018:	ff 36                	push   (%esi)
8010501a:	e8 d1 c6 ff ff       	call   801016f0 <ialloc>
8010501f:	83 c4 10             	add    $0x10,%esp
80105022:	89 c7                	mov    %eax,%edi
80105024:	85 c0                	test   %eax,%eax
80105026:	0f 84 af 00 00 00    	je     801050db <create+0x15b>
  ilock(ip);
8010502c:	83 ec 0c             	sub    $0xc,%esp
8010502f:	50                   	push   %eax
80105030:	e8 3b c8 ff ff       	call   80101870 <ilock>
  ip->major = major;
80105035:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105039:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010503d:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105041:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105045:	b8 01 00 00 00       	mov    $0x1,%eax
8010504a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010504e:	89 3c 24             	mov    %edi,(%esp)
80105051:	e8 5a c7 ff ff       	call   801017b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105056:	83 c4 10             	add    $0x10,%esp
80105059:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010505e:	74 30                	je     80105090 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80105060:	83 ec 04             	sub    $0x4,%esp
80105063:	ff 77 04             	push   0x4(%edi)
80105066:	53                   	push   %ebx
80105067:	56                   	push   %esi
80105068:	e8 63 d0 ff ff       	call   801020d0 <dirlink>
8010506d:	83 c4 10             	add    $0x10,%esp
80105070:	85 c0                	test   %eax,%eax
80105072:	78 74                	js     801050e8 <create+0x168>
  iunlockput(dp);
80105074:	83 ec 0c             	sub    $0xc,%esp
80105077:	56                   	push   %esi
80105078:	e8 93 ca ff ff       	call   80101b10 <iunlockput>
  return ip;
8010507d:	83 c4 10             	add    $0x10,%esp
}
80105080:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105083:	89 f8                	mov    %edi,%eax
80105085:	5b                   	pop    %ebx
80105086:	5e                   	pop    %esi
80105087:	5f                   	pop    %edi
80105088:	5d                   	pop    %ebp
80105089:	c3                   	ret
8010508a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105090:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105093:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80105098:	56                   	push   %esi
80105099:	e8 12 c7 ff ff       	call   801017b0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010509e:	83 c4 0c             	add    $0xc,%esp
801050a1:	ff 77 04             	push   0x4(%edi)
801050a4:	68 89 7a 10 80       	push   $0x80107a89
801050a9:	57                   	push   %edi
801050aa:	e8 21 d0 ff ff       	call   801020d0 <dirlink>
801050af:	83 c4 10             	add    $0x10,%esp
801050b2:	85 c0                	test   %eax,%eax
801050b4:	78 18                	js     801050ce <create+0x14e>
801050b6:	83 ec 04             	sub    $0x4,%esp
801050b9:	ff 76 04             	push   0x4(%esi)
801050bc:	68 88 7a 10 80       	push   $0x80107a88
801050c1:	57                   	push   %edi
801050c2:	e8 09 d0 ff ff       	call   801020d0 <dirlink>
801050c7:	83 c4 10             	add    $0x10,%esp
801050ca:	85 c0                	test   %eax,%eax
801050cc:	79 92                	jns    80105060 <create+0xe0>
      panic("create dots");
801050ce:	83 ec 0c             	sub    $0xc,%esp
801050d1:	68 7c 7a 10 80       	push   $0x80107a7c
801050d6:	e8 c5 b2 ff ff       	call   801003a0 <panic>
    panic("create: ialloc");
801050db:	83 ec 0c             	sub    $0xc,%esp
801050de:	68 6d 7a 10 80       	push   $0x80107a6d
801050e3:	e8 b8 b2 ff ff       	call   801003a0 <panic>
    panic("create: dirlink");
801050e8:	83 ec 0c             	sub    $0xc,%esp
801050eb:	68 8b 7a 10 80       	push   $0x80107a8b
801050f0:	e8 ab b2 ff ff       	call   801003a0 <panic>
801050f5:	8d 76 00             	lea    0x0(%esi),%esi
801050f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801050ff:	00 

80105100 <sys_dup>:
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	56                   	push   %esi
80105104:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105105:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105108:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010510b:	50                   	push   %eax
8010510c:	6a 00                	push   $0x0
8010510e:	e8 bd fc ff ff       	call   80104dd0 <argint>
80105113:	83 c4 10             	add    $0x10,%esp
80105116:	85 c0                	test   %eax,%eax
80105118:	78 36                	js     80105150 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010511a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010511e:	77 30                	ja     80105150 <sys_dup+0x50>
80105120:	e8 7b ea ff ff       	call   80103ba0 <myproc>
80105125:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105128:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010512c:	85 f6                	test   %esi,%esi
8010512e:	74 20                	je     80105150 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105130:	e8 6b ea ff ff       	call   80103ba0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105135:	31 db                	xor    %ebx,%ebx
80105137:	90                   	nop
80105138:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010513f:	00 
    if(curproc->ofile[fd] == 0){
80105140:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105144:	85 d2                	test   %edx,%edx
80105146:	74 18                	je     80105160 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105148:	83 c3 01             	add    $0x1,%ebx
8010514b:	83 fb 10             	cmp    $0x10,%ebx
8010514e:	75 f0                	jne    80105140 <sys_dup+0x40>
    return -1;
80105150:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105155:	eb 19                	jmp    80105170 <sys_dup+0x70>
80105157:	90                   	nop
80105158:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010515f:	00 
  filedup(f);
80105160:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105163:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105167:	56                   	push   %esi
80105168:	e8 c3 bd ff ff       	call   80100f30 <filedup>
  return fd;
8010516d:	83 c4 10             	add    $0x10,%esp
}
80105170:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105173:	89 d8                	mov    %ebx,%eax
80105175:	5b                   	pop    %ebx
80105176:	5e                   	pop    %esi
80105177:	5d                   	pop    %ebp
80105178:	c3                   	ret
80105179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105180 <sys_read>:
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	56                   	push   %esi
80105184:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105185:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105188:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010518b:	53                   	push   %ebx
8010518c:	6a 00                	push   $0x0
8010518e:	e8 3d fc ff ff       	call   80104dd0 <argint>
80105193:	83 c4 10             	add    $0x10,%esp
80105196:	85 c0                	test   %eax,%eax
80105198:	78 5e                	js     801051f8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010519a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010519e:	77 58                	ja     801051f8 <sys_read+0x78>
801051a0:	e8 fb e9 ff ff       	call   80103ba0 <myproc>
801051a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051a8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801051ac:	85 f6                	test   %esi,%esi
801051ae:	74 48                	je     801051f8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051b0:	83 ec 08             	sub    $0x8,%esp
801051b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051b6:	50                   	push   %eax
801051b7:	6a 02                	push   $0x2
801051b9:	e8 12 fc ff ff       	call   80104dd0 <argint>
801051be:	83 c4 10             	add    $0x10,%esp
801051c1:	85 c0                	test   %eax,%eax
801051c3:	78 33                	js     801051f8 <sys_read+0x78>
801051c5:	83 ec 04             	sub    $0x4,%esp
801051c8:	ff 75 f0             	push   -0x10(%ebp)
801051cb:	53                   	push   %ebx
801051cc:	6a 01                	push   $0x1
801051ce:	e8 4d fc ff ff       	call   80104e20 <argptr>
801051d3:	83 c4 10             	add    $0x10,%esp
801051d6:	85 c0                	test   %eax,%eax
801051d8:	78 1e                	js     801051f8 <sys_read+0x78>
  return fileread(f, p, n);
801051da:	83 ec 04             	sub    $0x4,%esp
801051dd:	ff 75 f0             	push   -0x10(%ebp)
801051e0:	ff 75 f4             	push   -0xc(%ebp)
801051e3:	56                   	push   %esi
801051e4:	e8 c7 be ff ff       	call   801010b0 <fileread>
801051e9:	83 c4 10             	add    $0x10,%esp
}
801051ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051ef:	5b                   	pop    %ebx
801051f0:	5e                   	pop    %esi
801051f1:	5d                   	pop    %ebp
801051f2:	c3                   	ret
801051f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
801051f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051fd:	eb ed                	jmp    801051ec <sys_read+0x6c>
801051ff:	90                   	nop

80105200 <sys_write>:
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	56                   	push   %esi
80105204:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105205:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105208:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010520b:	53                   	push   %ebx
8010520c:	6a 00                	push   $0x0
8010520e:	e8 bd fb ff ff       	call   80104dd0 <argint>
80105213:	83 c4 10             	add    $0x10,%esp
80105216:	85 c0                	test   %eax,%eax
80105218:	78 5e                	js     80105278 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010521a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010521e:	77 58                	ja     80105278 <sys_write+0x78>
80105220:	e8 7b e9 ff ff       	call   80103ba0 <myproc>
80105225:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105228:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010522c:	85 f6                	test   %esi,%esi
8010522e:	74 48                	je     80105278 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105230:	83 ec 08             	sub    $0x8,%esp
80105233:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105236:	50                   	push   %eax
80105237:	6a 02                	push   $0x2
80105239:	e8 92 fb ff ff       	call   80104dd0 <argint>
8010523e:	83 c4 10             	add    $0x10,%esp
80105241:	85 c0                	test   %eax,%eax
80105243:	78 33                	js     80105278 <sys_write+0x78>
80105245:	83 ec 04             	sub    $0x4,%esp
80105248:	ff 75 f0             	push   -0x10(%ebp)
8010524b:	53                   	push   %ebx
8010524c:	6a 01                	push   $0x1
8010524e:	e8 cd fb ff ff       	call   80104e20 <argptr>
80105253:	83 c4 10             	add    $0x10,%esp
80105256:	85 c0                	test   %eax,%eax
80105258:	78 1e                	js     80105278 <sys_write+0x78>
  return filewrite(f, p, n);
8010525a:	83 ec 04             	sub    $0x4,%esp
8010525d:	ff 75 f0             	push   -0x10(%ebp)
80105260:	ff 75 f4             	push   -0xc(%ebp)
80105263:	56                   	push   %esi
80105264:	e8 d7 be ff ff       	call   80101140 <filewrite>
80105269:	83 c4 10             	add    $0x10,%esp
}
8010526c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010526f:	5b                   	pop    %ebx
80105270:	5e                   	pop    %esi
80105271:	5d                   	pop    %ebp
80105272:	c3                   	ret
80105273:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105278:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010527d:	eb ed                	jmp    8010526c <sys_write+0x6c>
8010527f:	90                   	nop

80105280 <sys_close>:
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	56                   	push   %esi
80105284:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105285:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105288:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010528b:	50                   	push   %eax
8010528c:	6a 00                	push   $0x0
8010528e:	e8 3d fb ff ff       	call   80104dd0 <argint>
80105293:	83 c4 10             	add    $0x10,%esp
80105296:	85 c0                	test   %eax,%eax
80105298:	78 3e                	js     801052d8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010529a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010529e:	77 38                	ja     801052d8 <sys_close+0x58>
801052a0:	e8 fb e8 ff ff       	call   80103ba0 <myproc>
801052a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052a8:	8d 5a 08             	lea    0x8(%edx),%ebx
801052ab:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801052af:	85 f6                	test   %esi,%esi
801052b1:	74 25                	je     801052d8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801052b3:	e8 e8 e8 ff ff       	call   80103ba0 <myproc>
  fileclose(f);
801052b8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801052bb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801052c2:	00 
  fileclose(f);
801052c3:	56                   	push   %esi
801052c4:	e8 b7 bc ff ff       	call   80100f80 <fileclose>
  return 0;
801052c9:	83 c4 10             	add    $0x10,%esp
801052cc:	31 c0                	xor    %eax,%eax
}
801052ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052d1:	5b                   	pop    %ebx
801052d2:	5e                   	pop    %esi
801052d3:	5d                   	pop    %ebp
801052d4:	c3                   	ret
801052d5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801052d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052dd:	eb ef                	jmp    801052ce <sys_close+0x4e>
801052df:	90                   	nop

801052e0 <sys_fstat>:
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	56                   	push   %esi
801052e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801052e5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801052e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801052eb:	53                   	push   %ebx
801052ec:	6a 00                	push   $0x0
801052ee:	e8 dd fa ff ff       	call   80104dd0 <argint>
801052f3:	83 c4 10             	add    $0x10,%esp
801052f6:	85 c0                	test   %eax,%eax
801052f8:	78 46                	js     80105340 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801052fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801052fe:	77 40                	ja     80105340 <sys_fstat+0x60>
80105300:	e8 9b e8 ff ff       	call   80103ba0 <myproc>
80105305:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105308:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010530c:	85 f6                	test   %esi,%esi
8010530e:	74 30                	je     80105340 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105310:	83 ec 04             	sub    $0x4,%esp
80105313:	6a 14                	push   $0x14
80105315:	53                   	push   %ebx
80105316:	6a 01                	push   $0x1
80105318:	e8 03 fb ff ff       	call   80104e20 <argptr>
8010531d:	83 c4 10             	add    $0x10,%esp
80105320:	85 c0                	test   %eax,%eax
80105322:	78 1c                	js     80105340 <sys_fstat+0x60>
  return filestat(f, st);
80105324:	83 ec 08             	sub    $0x8,%esp
80105327:	ff 75 f4             	push   -0xc(%ebp)
8010532a:	56                   	push   %esi
8010532b:	e8 30 bd ff ff       	call   80101060 <filestat>
80105330:	83 c4 10             	add    $0x10,%esp
}
80105333:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105336:	5b                   	pop    %ebx
80105337:	5e                   	pop    %esi
80105338:	5d                   	pop    %ebp
80105339:	c3                   	ret
8010533a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105340:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105345:	eb ec                	jmp    80105333 <sys_fstat+0x53>
80105347:	90                   	nop
80105348:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010534f:	00 

80105350 <sys_link>:
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	57                   	push   %edi
80105354:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105355:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105358:	53                   	push   %ebx
80105359:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010535c:	50                   	push   %eax
8010535d:	6a 00                	push   $0x0
8010535f:	e8 2c fb ff ff       	call   80104e90 <argstr>
80105364:	83 c4 10             	add    $0x10,%esp
80105367:	85 c0                	test   %eax,%eax
80105369:	0f 88 fb 00 00 00    	js     8010546a <sys_link+0x11a>
8010536f:	83 ec 08             	sub    $0x8,%esp
80105372:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105375:	50                   	push   %eax
80105376:	6a 01                	push   $0x1
80105378:	e8 13 fb ff ff       	call   80104e90 <argstr>
8010537d:	83 c4 10             	add    $0x10,%esp
80105380:	85 c0                	test   %eax,%eax
80105382:	0f 88 e2 00 00 00    	js     8010546a <sys_link+0x11a>
  begin_op();
80105388:	e8 53 db ff ff       	call   80102ee0 <begin_op>
  if((ip = namei(old)) == 0){
8010538d:	83 ec 0c             	sub    $0xc,%esp
80105390:	ff 75 d4             	push   -0x2c(%ebp)
80105393:	e8 f8 cd ff ff       	call   80102190 <namei>
80105398:	83 c4 10             	add    $0x10,%esp
8010539b:	89 c3                	mov    %eax,%ebx
8010539d:	85 c0                	test   %eax,%eax
8010539f:	0f 84 df 00 00 00    	je     80105484 <sys_link+0x134>
  ilock(ip);
801053a5:	83 ec 0c             	sub    $0xc,%esp
801053a8:	50                   	push   %eax
801053a9:	e8 c2 c4 ff ff       	call   80101870 <ilock>
  if(ip->type == T_DIR){
801053ae:	83 c4 10             	add    $0x10,%esp
801053b1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053b6:	0f 84 b5 00 00 00    	je     80105471 <sys_link+0x121>
  iupdate(ip);
801053bc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801053bf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801053c4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801053c7:	53                   	push   %ebx
801053c8:	e8 e3 c3 ff ff       	call   801017b0 <iupdate>
  iunlock(ip);
801053cd:	89 1c 24             	mov    %ebx,(%esp)
801053d0:	e8 7b c5 ff ff       	call   80101950 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801053d5:	58                   	pop    %eax
801053d6:	5a                   	pop    %edx
801053d7:	57                   	push   %edi
801053d8:	ff 75 d0             	push   -0x30(%ebp)
801053db:	e8 d0 cd ff ff       	call   801021b0 <nameiparent>
801053e0:	83 c4 10             	add    $0x10,%esp
801053e3:	89 c6                	mov    %eax,%esi
801053e5:	85 c0                	test   %eax,%eax
801053e7:	74 5b                	je     80105444 <sys_link+0xf4>
  ilock(dp);
801053e9:	83 ec 0c             	sub    $0xc,%esp
801053ec:	50                   	push   %eax
801053ed:	e8 7e c4 ff ff       	call   80101870 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801053f2:	8b 03                	mov    (%ebx),%eax
801053f4:	83 c4 10             	add    $0x10,%esp
801053f7:	39 06                	cmp    %eax,(%esi)
801053f9:	75 3d                	jne    80105438 <sys_link+0xe8>
801053fb:	83 ec 04             	sub    $0x4,%esp
801053fe:	ff 73 04             	push   0x4(%ebx)
80105401:	57                   	push   %edi
80105402:	56                   	push   %esi
80105403:	e8 c8 cc ff ff       	call   801020d0 <dirlink>
80105408:	83 c4 10             	add    $0x10,%esp
8010540b:	85 c0                	test   %eax,%eax
8010540d:	78 29                	js     80105438 <sys_link+0xe8>
  iunlockput(dp);
8010540f:	83 ec 0c             	sub    $0xc,%esp
80105412:	56                   	push   %esi
80105413:	e8 f8 c6 ff ff       	call   80101b10 <iunlockput>
  iput(ip);
80105418:	89 1c 24             	mov    %ebx,(%esp)
8010541b:	e8 80 c5 ff ff       	call   801019a0 <iput>
  end_op();
80105420:	e8 2b db ff ff       	call   80102f50 <end_op>
  return 0;
80105425:	83 c4 10             	add    $0x10,%esp
80105428:	31 c0                	xor    %eax,%eax
}
8010542a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010542d:	5b                   	pop    %ebx
8010542e:	5e                   	pop    %esi
8010542f:	5f                   	pop    %edi
80105430:	5d                   	pop    %ebp
80105431:	c3                   	ret
80105432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105438:	83 ec 0c             	sub    $0xc,%esp
8010543b:	56                   	push   %esi
8010543c:	e8 cf c6 ff ff       	call   80101b10 <iunlockput>
    goto bad;
80105441:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105444:	83 ec 0c             	sub    $0xc,%esp
80105447:	53                   	push   %ebx
80105448:	e8 23 c4 ff ff       	call   80101870 <ilock>
  ip->nlink--;
8010544d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105452:	89 1c 24             	mov    %ebx,(%esp)
80105455:	e8 56 c3 ff ff       	call   801017b0 <iupdate>
  iunlockput(ip);
8010545a:	89 1c 24             	mov    %ebx,(%esp)
8010545d:	e8 ae c6 ff ff       	call   80101b10 <iunlockput>
  end_op();
80105462:	e8 e9 da ff ff       	call   80102f50 <end_op>
  return -1;
80105467:	83 c4 10             	add    $0x10,%esp
    return -1;
8010546a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010546f:	eb b9                	jmp    8010542a <sys_link+0xda>
    iunlockput(ip);
80105471:	83 ec 0c             	sub    $0xc,%esp
80105474:	53                   	push   %ebx
80105475:	e8 96 c6 ff ff       	call   80101b10 <iunlockput>
    end_op();
8010547a:	e8 d1 da ff ff       	call   80102f50 <end_op>
    return -1;
8010547f:	83 c4 10             	add    $0x10,%esp
80105482:	eb e6                	jmp    8010546a <sys_link+0x11a>
    end_op();
80105484:	e8 c7 da ff ff       	call   80102f50 <end_op>
    return -1;
80105489:	eb df                	jmp    8010546a <sys_link+0x11a>
8010548b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105490 <sys_unlink>:
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	57                   	push   %edi
80105494:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105495:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105498:	53                   	push   %ebx
80105499:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010549c:	50                   	push   %eax
8010549d:	6a 00                	push   $0x0
8010549f:	e8 ec f9 ff ff       	call   80104e90 <argstr>
801054a4:	83 c4 10             	add    $0x10,%esp
801054a7:	85 c0                	test   %eax,%eax
801054a9:	0f 88 54 01 00 00    	js     80105603 <sys_unlink+0x173>
  begin_op();
801054af:	e8 2c da ff ff       	call   80102ee0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801054b4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801054b7:	83 ec 08             	sub    $0x8,%esp
801054ba:	53                   	push   %ebx
801054bb:	ff 75 c0             	push   -0x40(%ebp)
801054be:	e8 ed cc ff ff       	call   801021b0 <nameiparent>
801054c3:	83 c4 10             	add    $0x10,%esp
801054c6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801054c9:	85 c0                	test   %eax,%eax
801054cb:	0f 84 58 01 00 00    	je     80105629 <sys_unlink+0x199>
  ilock(dp);
801054d1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801054d4:	83 ec 0c             	sub    $0xc,%esp
801054d7:	57                   	push   %edi
801054d8:	e8 93 c3 ff ff       	call   80101870 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801054dd:	58                   	pop    %eax
801054de:	5a                   	pop    %edx
801054df:	68 89 7a 10 80       	push   $0x80107a89
801054e4:	53                   	push   %ebx
801054e5:	e8 c6 c8 ff ff       	call   80101db0 <namecmp>
801054ea:	83 c4 10             	add    $0x10,%esp
801054ed:	85 c0                	test   %eax,%eax
801054ef:	0f 84 fb 00 00 00    	je     801055f0 <sys_unlink+0x160>
801054f5:	83 ec 08             	sub    $0x8,%esp
801054f8:	68 88 7a 10 80       	push   $0x80107a88
801054fd:	53                   	push   %ebx
801054fe:	e8 ad c8 ff ff       	call   80101db0 <namecmp>
80105503:	83 c4 10             	add    $0x10,%esp
80105506:	85 c0                	test   %eax,%eax
80105508:	0f 84 e2 00 00 00    	je     801055f0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010550e:	83 ec 04             	sub    $0x4,%esp
80105511:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105514:	50                   	push   %eax
80105515:	53                   	push   %ebx
80105516:	57                   	push   %edi
80105517:	e8 b4 c8 ff ff       	call   80101dd0 <dirlookup>
8010551c:	83 c4 10             	add    $0x10,%esp
8010551f:	89 c3                	mov    %eax,%ebx
80105521:	85 c0                	test   %eax,%eax
80105523:	0f 84 c7 00 00 00    	je     801055f0 <sys_unlink+0x160>
  ilock(ip);
80105529:	83 ec 0c             	sub    $0xc,%esp
8010552c:	50                   	push   %eax
8010552d:	e8 3e c3 ff ff       	call   80101870 <ilock>
  if(ip->nlink < 1)
80105532:	83 c4 10             	add    $0x10,%esp
80105535:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010553a:	0f 8e fd 00 00 00    	jle    8010563d <sys_unlink+0x1ad>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105540:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105543:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105548:	74 66                	je     801055b0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010554a:	83 ec 04             	sub    $0x4,%esp
8010554d:	6a 10                	push   $0x10
8010554f:	6a 00                	push   $0x0
80105551:	57                   	push   %edi
80105552:	e8 a9 f5 ff ff       	call   80104b00 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105557:	6a 10                	push   $0x10
80105559:	ff 75 c4             	push   -0x3c(%ebp)
8010555c:	57                   	push   %edi
8010555d:	ff 75 b4             	push   -0x4c(%ebp)
80105560:	e8 2b c7 ff ff       	call   80101c90 <writei>
80105565:	83 c4 20             	add    $0x20,%esp
80105568:	83 f8 10             	cmp    $0x10,%eax
8010556b:	0f 85 d9 00 00 00    	jne    8010564a <sys_unlink+0x1ba>
  if(ip->type == T_DIR){
80105571:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105576:	0f 84 94 00 00 00    	je     80105610 <sys_unlink+0x180>
  iunlockput(dp);
8010557c:	83 ec 0c             	sub    $0xc,%esp
8010557f:	ff 75 b4             	push   -0x4c(%ebp)
80105582:	e8 89 c5 ff ff       	call   80101b10 <iunlockput>
  ip->nlink--;
80105587:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010558c:	89 1c 24             	mov    %ebx,(%esp)
8010558f:	e8 1c c2 ff ff       	call   801017b0 <iupdate>
  iunlockput(ip);
80105594:	89 1c 24             	mov    %ebx,(%esp)
80105597:	e8 74 c5 ff ff       	call   80101b10 <iunlockput>
  end_op();
8010559c:	e8 af d9 ff ff       	call   80102f50 <end_op>
  return 0;
801055a1:	83 c4 10             	add    $0x10,%esp
801055a4:	31 c0                	xor    %eax,%eax
}
801055a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055a9:	5b                   	pop    %ebx
801055aa:	5e                   	pop    %esi
801055ab:	5f                   	pop    %edi
801055ac:	5d                   	pop    %ebp
801055ad:	c3                   	ret
801055ae:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801055b0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801055b4:	76 94                	jbe    8010554a <sys_unlink+0xba>
801055b6:	be 20 00 00 00       	mov    $0x20,%esi
801055bb:	eb 0b                	jmp    801055c8 <sys_unlink+0x138>
801055bd:	8d 76 00             	lea    0x0(%esi),%esi
801055c0:	83 c6 10             	add    $0x10,%esi
801055c3:	3b 73 58             	cmp    0x58(%ebx),%esi
801055c6:	73 82                	jae    8010554a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055c8:	6a 10                	push   $0x10
801055ca:	56                   	push   %esi
801055cb:	57                   	push   %edi
801055cc:	53                   	push   %ebx
801055cd:	e8 be c5 ff ff       	call   80101b90 <readi>
801055d2:	83 c4 10             	add    $0x10,%esp
801055d5:	83 f8 10             	cmp    $0x10,%eax
801055d8:	75 56                	jne    80105630 <sys_unlink+0x1a0>
    if(de.inum != 0)
801055da:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801055df:	74 df                	je     801055c0 <sys_unlink+0x130>
    iunlockput(ip);
801055e1:	83 ec 0c             	sub    $0xc,%esp
801055e4:	53                   	push   %ebx
801055e5:	e8 26 c5 ff ff       	call   80101b10 <iunlockput>
    goto bad;
801055ea:	83 c4 10             	add    $0x10,%esp
801055ed:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801055f0:	83 ec 0c             	sub    $0xc,%esp
801055f3:	ff 75 b4             	push   -0x4c(%ebp)
801055f6:	e8 15 c5 ff ff       	call   80101b10 <iunlockput>
  end_op();
801055fb:	e8 50 d9 ff ff       	call   80102f50 <end_op>
  return -1;
80105600:	83 c4 10             	add    $0x10,%esp
    return -1;
80105603:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105608:	eb 9c                	jmp    801055a6 <sys_unlink+0x116>
8010560a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105610:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105613:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105616:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010561b:	50                   	push   %eax
8010561c:	e8 8f c1 ff ff       	call   801017b0 <iupdate>
80105621:	83 c4 10             	add    $0x10,%esp
80105624:	e9 53 ff ff ff       	jmp    8010557c <sys_unlink+0xec>
    end_op();
80105629:	e8 22 d9 ff ff       	call   80102f50 <end_op>
    return -1;
8010562e:	eb d3                	jmp    80105603 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105630:	83 ec 0c             	sub    $0xc,%esp
80105633:	68 ad 7a 10 80       	push   $0x80107aad
80105638:	e8 63 ad ff ff       	call   801003a0 <panic>
    panic("unlink: nlink < 1");
8010563d:	83 ec 0c             	sub    $0xc,%esp
80105640:	68 9b 7a 10 80       	push   $0x80107a9b
80105645:	e8 56 ad ff ff       	call   801003a0 <panic>
    panic("unlink: writei");
8010564a:	83 ec 0c             	sub    $0xc,%esp
8010564d:	68 bf 7a 10 80       	push   $0x80107abf
80105652:	e8 49 ad ff ff       	call   801003a0 <panic>
80105657:	90                   	nop
80105658:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010565f:	00 

80105660 <sys_open>:

int
sys_open(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	57                   	push   %edi
80105664:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105665:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105668:	53                   	push   %ebx
80105669:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010566c:	50                   	push   %eax
8010566d:	6a 00                	push   $0x0
8010566f:	e8 1c f8 ff ff       	call   80104e90 <argstr>
80105674:	83 c4 10             	add    $0x10,%esp
80105677:	85 c0                	test   %eax,%eax
80105679:	0f 88 8e 00 00 00    	js     8010570d <sys_open+0xad>
8010567f:	83 ec 08             	sub    $0x8,%esp
80105682:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105685:	50                   	push   %eax
80105686:	6a 01                	push   $0x1
80105688:	e8 43 f7 ff ff       	call   80104dd0 <argint>
8010568d:	83 c4 10             	add    $0x10,%esp
80105690:	85 c0                	test   %eax,%eax
80105692:	78 79                	js     8010570d <sys_open+0xad>
    return -1;

  begin_op();
80105694:	e8 47 d8 ff ff       	call   80102ee0 <begin_op>

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105699:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(omode & O_CREATE){
8010569c:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801056a0:	75 76                	jne    80105718 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801056a2:	83 ec 0c             	sub    $0xc,%esp
801056a5:	50                   	push   %eax
801056a6:	e8 e5 ca ff ff       	call   80102190 <namei>
801056ab:	83 c4 10             	add    $0x10,%esp
801056ae:	89 c7                	mov    %eax,%edi
801056b0:	85 c0                	test   %eax,%eax
801056b2:	74 7e                	je     80105732 <sys_open+0xd2>
      end_op();
      return -1;
    }
    ilock(ip);
801056b4:	83 ec 0c             	sub    $0xc,%esp
801056b7:	50                   	push   %eax
801056b8:	e8 b3 c1 ff ff       	call   80101870 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801056bd:	83 c4 10             	add    $0x10,%esp
801056c0:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
801056c5:	0f 84 bd 00 00 00    	je     80105788 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801056cb:	e8 f0 b7 ff ff       	call   80100ec0 <filealloc>
801056d0:	89 c6                	mov    %eax,%esi
801056d2:	85 c0                	test   %eax,%eax
801056d4:	74 26                	je     801056fc <sys_open+0x9c>
  struct proc *curproc = myproc();
801056d6:	e8 c5 e4 ff ff       	call   80103ba0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056db:	31 db                	xor    %ebx,%ebx
801056dd:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
801056e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801056e4:	85 d2                	test   %edx,%edx
801056e6:	74 58                	je     80105740 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
801056e8:	83 c3 01             	add    $0x1,%ebx
801056eb:	83 fb 10             	cmp    $0x10,%ebx
801056ee:	75 f0                	jne    801056e0 <sys_open+0x80>
    if(f)
      fileclose(f);
801056f0:	83 ec 0c             	sub    $0xc,%esp
801056f3:	56                   	push   %esi
801056f4:	e8 87 b8 ff ff       	call   80100f80 <fileclose>
801056f9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801056fc:	83 ec 0c             	sub    $0xc,%esp
801056ff:	57                   	push   %edi
80105700:	e8 0b c4 ff ff       	call   80101b10 <iunlockput>
    end_op();
80105705:	e8 46 d8 ff ff       	call   80102f50 <end_op>
    return -1;
8010570a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010570d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105712:	eb 65                	jmp    80105779 <sys_open+0x119>
80105714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105718:	83 ec 0c             	sub    $0xc,%esp
8010571b:	31 c9                	xor    %ecx,%ecx
8010571d:	ba 02 00 00 00       	mov    $0x2,%edx
80105722:	6a 00                	push   $0x0
80105724:	e8 57 f8 ff ff       	call   80104f80 <create>
    if(ip == 0){
80105729:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010572c:	89 c7                	mov    %eax,%edi
    if(ip == 0){
8010572e:	85 c0                	test   %eax,%eax
80105730:	75 99                	jne    801056cb <sys_open+0x6b>
      end_op();
80105732:	e8 19 d8 ff ff       	call   80102f50 <end_op>
      return -1;
80105737:	eb d4                	jmp    8010570d <sys_open+0xad>
80105739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105740:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105743:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105747:	57                   	push   %edi
80105748:	e8 03 c2 ff ff       	call   80101950 <iunlock>
  end_op();
8010574d:	e8 fe d7 ff ff       	call   80102f50 <end_op>

  f->type = FD_INODE;
80105752:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105758:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010575b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010575e:	89 7e 10             	mov    %edi,0x10(%esi)
  f->readable = !(omode & O_WRONLY);
80105761:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105763:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
8010576a:	f7 d0                	not    %eax
8010576c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010576f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105772:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105775:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
}
80105779:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010577c:	89 d8                	mov    %ebx,%eax
8010577e:	5b                   	pop    %ebx
8010577f:	5e                   	pop    %esi
80105780:	5f                   	pop    %edi
80105781:	5d                   	pop    %ebp
80105782:	c3                   	ret
80105783:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105788:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010578b:	85 c9                	test   %ecx,%ecx
8010578d:	0f 84 38 ff ff ff    	je     801056cb <sys_open+0x6b>
80105793:	e9 64 ff ff ff       	jmp    801056fc <sys_open+0x9c>
80105798:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010579f:	00 

801057a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801057a6:	e8 35 d7 ff ff       	call   80102ee0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801057ab:	83 ec 08             	sub    $0x8,%esp
801057ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057b1:	50                   	push   %eax
801057b2:	6a 00                	push   $0x0
801057b4:	e8 d7 f6 ff ff       	call   80104e90 <argstr>
801057b9:	83 c4 10             	add    $0x10,%esp
801057bc:	85 c0                	test   %eax,%eax
801057be:	78 30                	js     801057f0 <sys_mkdir+0x50>
801057c0:	83 ec 0c             	sub    $0xc,%esp
801057c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057c6:	31 c9                	xor    %ecx,%ecx
801057c8:	ba 01 00 00 00       	mov    $0x1,%edx
801057cd:	6a 00                	push   $0x0
801057cf:	e8 ac f7 ff ff       	call   80104f80 <create>
801057d4:	83 c4 10             	add    $0x10,%esp
801057d7:	85 c0                	test   %eax,%eax
801057d9:	74 15                	je     801057f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057db:	83 ec 0c             	sub    $0xc,%esp
801057de:	50                   	push   %eax
801057df:	e8 2c c3 ff ff       	call   80101b10 <iunlockput>
  end_op();
801057e4:	e8 67 d7 ff ff       	call   80102f50 <end_op>
  return 0;
801057e9:	83 c4 10             	add    $0x10,%esp
801057ec:	31 c0                	xor    %eax,%eax
}
801057ee:	c9                   	leave
801057ef:	c3                   	ret
    end_op();
801057f0:	e8 5b d7 ff ff       	call   80102f50 <end_op>
    return -1;
801057f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057fa:	c9                   	leave
801057fb:	c3                   	ret
801057fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105800 <sys_mknod>:

int
sys_mknod(void)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105806:	e8 d5 d6 ff ff       	call   80102ee0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010580b:	83 ec 08             	sub    $0x8,%esp
8010580e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105811:	50                   	push   %eax
80105812:	6a 00                	push   $0x0
80105814:	e8 77 f6 ff ff       	call   80104e90 <argstr>
80105819:	83 c4 10             	add    $0x10,%esp
8010581c:	85 c0                	test   %eax,%eax
8010581e:	78 60                	js     80105880 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105820:	83 ec 08             	sub    $0x8,%esp
80105823:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105826:	50                   	push   %eax
80105827:	6a 01                	push   $0x1
80105829:	e8 a2 f5 ff ff       	call   80104dd0 <argint>
  if((argstr(0, &path)) < 0 ||
8010582e:	83 c4 10             	add    $0x10,%esp
80105831:	85 c0                	test   %eax,%eax
80105833:	78 4b                	js     80105880 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105835:	83 ec 08             	sub    $0x8,%esp
80105838:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010583b:	50                   	push   %eax
8010583c:	6a 02                	push   $0x2
8010583e:	e8 8d f5 ff ff       	call   80104dd0 <argint>
     argint(1, &major) < 0 ||
80105843:	83 c4 10             	add    $0x10,%esp
80105846:	85 c0                	test   %eax,%eax
80105848:	78 36                	js     80105880 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010584a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010584e:	83 ec 0c             	sub    $0xc,%esp
80105851:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105855:	ba 03 00 00 00       	mov    $0x3,%edx
8010585a:	50                   	push   %eax
8010585b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010585e:	e8 1d f7 ff ff       	call   80104f80 <create>
     argint(2, &minor) < 0 ||
80105863:	83 c4 10             	add    $0x10,%esp
80105866:	85 c0                	test   %eax,%eax
80105868:	74 16                	je     80105880 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010586a:	83 ec 0c             	sub    $0xc,%esp
8010586d:	50                   	push   %eax
8010586e:	e8 9d c2 ff ff       	call   80101b10 <iunlockput>
  end_op();
80105873:	e8 d8 d6 ff ff       	call   80102f50 <end_op>
  return 0;
80105878:	83 c4 10             	add    $0x10,%esp
8010587b:	31 c0                	xor    %eax,%eax
}
8010587d:	c9                   	leave
8010587e:	c3                   	ret
8010587f:	90                   	nop
    end_op();
80105880:	e8 cb d6 ff ff       	call   80102f50 <end_op>
    return -1;
80105885:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010588a:	c9                   	leave
8010588b:	c3                   	ret
8010588c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105890 <sys_chdir>:

int
sys_chdir(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	56                   	push   %esi
80105894:	53                   	push   %ebx
80105895:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105898:	e8 03 e3 ff ff       	call   80103ba0 <myproc>
8010589d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010589f:	e8 3c d6 ff ff       	call   80102ee0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801058a4:	83 ec 08             	sub    $0x8,%esp
801058a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058aa:	50                   	push   %eax
801058ab:	6a 00                	push   $0x0
801058ad:	e8 de f5 ff ff       	call   80104e90 <argstr>
801058b2:	83 c4 10             	add    $0x10,%esp
801058b5:	85 c0                	test   %eax,%eax
801058b7:	78 77                	js     80105930 <sys_chdir+0xa0>
801058b9:	83 ec 0c             	sub    $0xc,%esp
801058bc:	ff 75 f4             	push   -0xc(%ebp)
801058bf:	e8 cc c8 ff ff       	call   80102190 <namei>
801058c4:	83 c4 10             	add    $0x10,%esp
801058c7:	89 c3                	mov    %eax,%ebx
801058c9:	85 c0                	test   %eax,%eax
801058cb:	74 63                	je     80105930 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801058cd:	83 ec 0c             	sub    $0xc,%esp
801058d0:	50                   	push   %eax
801058d1:	e8 9a bf ff ff       	call   80101870 <ilock>
  if(ip->type != T_DIR){
801058d6:	83 c4 10             	add    $0x10,%esp
801058d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058de:	75 30                	jne    80105910 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801058e0:	83 ec 0c             	sub    $0xc,%esp
801058e3:	53                   	push   %ebx
801058e4:	e8 67 c0 ff ff       	call   80101950 <iunlock>
  iput(curproc->cwd);
801058e9:	58                   	pop    %eax
801058ea:	ff 76 68             	push   0x68(%esi)
801058ed:	e8 ae c0 ff ff       	call   801019a0 <iput>
  end_op();
801058f2:	e8 59 d6 ff ff       	call   80102f50 <end_op>
  curproc->cwd = ip;
801058f7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801058fa:	83 c4 10             	add    $0x10,%esp
801058fd:	31 c0                	xor    %eax,%eax
}
801058ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105902:	5b                   	pop    %ebx
80105903:	5e                   	pop    %esi
80105904:	5d                   	pop    %ebp
80105905:	c3                   	ret
80105906:	66 90                	xchg   %ax,%ax
80105908:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010590f:	00 
    iunlockput(ip);
80105910:	83 ec 0c             	sub    $0xc,%esp
80105913:	53                   	push   %ebx
80105914:	e8 f7 c1 ff ff       	call   80101b10 <iunlockput>
    end_op();
80105919:	e8 32 d6 ff ff       	call   80102f50 <end_op>
    return -1;
8010591e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105921:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105926:	eb d7                	jmp    801058ff <sys_chdir+0x6f>
80105928:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010592f:	00 
    end_op();
80105930:	e8 1b d6 ff ff       	call   80102f50 <end_op>
    return -1;
80105935:	eb ea                	jmp    80105921 <sys_chdir+0x91>
80105937:	90                   	nop
80105938:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010593f:	00 

80105940 <sys_exec>:

int
sys_exec(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	57                   	push   %edi
80105944:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105945:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010594b:	53                   	push   %ebx
8010594c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105952:	50                   	push   %eax
80105953:	6a 00                	push   $0x0
80105955:	e8 36 f5 ff ff       	call   80104e90 <argstr>
8010595a:	83 c4 10             	add    $0x10,%esp
8010595d:	85 c0                	test   %eax,%eax
8010595f:	0f 88 85 00 00 00    	js     801059ea <sys_exec+0xaa>
80105965:	83 ec 08             	sub    $0x8,%esp
80105968:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010596e:	50                   	push   %eax
8010596f:	6a 01                	push   $0x1
80105971:	e8 5a f4 ff ff       	call   80104dd0 <argint>
80105976:	83 c4 10             	add    $0x10,%esp
80105979:	85 c0                	test   %eax,%eax
8010597b:	78 6d                	js     801059ea <sys_exec+0xaa>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010597d:	83 ec 04             	sub    $0x4,%esp
80105980:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105986:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105988:	68 80 00 00 00       	push   $0x80
8010598d:	6a 00                	push   $0x0
8010598f:	56                   	push   %esi
80105990:	e8 6b f1 ff ff       	call   80104b00 <memset>
80105995:	83 c4 10             	add    $0x10,%esp
80105998:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010599f:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801059a0:	83 ec 08             	sub    $0x8,%esp
801059a3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801059a9:	50                   	push   %eax
801059aa:	8d 04 9d 00 00 00 00 	lea    0x0(,%ebx,4),%eax
801059b1:	03 85 60 ff ff ff    	add    -0xa0(%ebp),%eax
801059b7:	50                   	push   %eax
801059b8:	e8 73 f3 ff ff       	call   80104d30 <fetchint>
801059bd:	83 c4 10             	add    $0x10,%esp
801059c0:	85 c0                	test   %eax,%eax
801059c2:	78 26                	js     801059ea <sys_exec+0xaa>
      return -1;
    if(uarg == 0){
801059c4:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801059ca:	85 c0                	test   %eax,%eax
801059cc:	74 32                	je     80105a00 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801059ce:	83 ec 08             	sub    $0x8,%esp
801059d1:	8d 14 9e             	lea    (%esi,%ebx,4),%edx
801059d4:	52                   	push   %edx
801059d5:	50                   	push   %eax
801059d6:	e8 95 f3 ff ff       	call   80104d70 <fetchstr>
801059db:	83 c4 10             	add    $0x10,%esp
801059de:	85 c0                	test   %eax,%eax
801059e0:	78 08                	js     801059ea <sys_exec+0xaa>
  for(i=0;; i++){
801059e2:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801059e5:	83 fb 20             	cmp    $0x20,%ebx
801059e8:	75 b6                	jne    801059a0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801059ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801059ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059f2:	5b                   	pop    %ebx
801059f3:	5e                   	pop    %esi
801059f4:	5f                   	pop    %edi
801059f5:	5d                   	pop    %ebp
801059f6:	c3                   	ret
801059f7:	90                   	nop
801059f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059ff:	00 
      argv[i] = 0;
80105a00:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105a07:	00 00 00 00 
  return exec(path, argv);
80105a0b:	83 ec 08             	sub    $0x8,%esp
80105a0e:	56                   	push   %esi
80105a0f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105a15:	e8 f6 b0 ff ff       	call   80100b10 <exec>
80105a1a:	83 c4 10             	add    $0x10,%esp
}
80105a1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a20:	5b                   	pop    %ebx
80105a21:	5e                   	pop    %esi
80105a22:	5f                   	pop    %edi
80105a23:	5d                   	pop    %ebp
80105a24:	c3                   	ret
80105a25:	8d 76 00             	lea    0x0(%esi),%esi
80105a28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a2f:	00 

80105a30 <sys_pipe>:

int
sys_pipe(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	57                   	push   %edi
80105a34:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a35:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105a38:	53                   	push   %ebx
80105a39:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a3c:	6a 08                	push   $0x8
80105a3e:	50                   	push   %eax
80105a3f:	6a 00                	push   $0x0
80105a41:	e8 da f3 ff ff       	call   80104e20 <argptr>
80105a46:	83 c4 10             	add    $0x10,%esp
80105a49:	85 c0                	test   %eax,%eax
80105a4b:	0f 88 93 00 00 00    	js     80105ae4 <sys_pipe+0xb4>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105a51:	83 ec 08             	sub    $0x8,%esp
80105a54:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a57:	50                   	push   %eax
80105a58:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105a5b:	50                   	push   %eax
80105a5c:	e8 5f db ff ff       	call   801035c0 <pipealloc>
80105a61:	83 c4 10             	add    $0x10,%esp
80105a64:	85 c0                	test   %eax,%eax
80105a66:	78 7c                	js     80105ae4 <sys_pipe+0xb4>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a68:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105a6b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105a6d:	e8 2e e1 ff ff       	call   80103ba0 <myproc>
    if(curproc->ofile[fd] == 0){
80105a72:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105a76:	85 f6                	test   %esi,%esi
80105a78:	74 16                	je     80105a90 <sys_pipe+0x60>
80105a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105a80:	83 c3 01             	add    $0x1,%ebx
80105a83:	83 fb 10             	cmp    $0x10,%ebx
80105a86:	74 45                	je     80105acd <sys_pipe+0x9d>
    if(curproc->ofile[fd] == 0){
80105a88:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105a8c:	85 f6                	test   %esi,%esi
80105a8e:	75 f0                	jne    80105a80 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105a90:	8d 73 08             	lea    0x8(%ebx),%esi
80105a93:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a97:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105a9a:	e8 01 e1 ff ff       	call   80103ba0 <myproc>
80105a9f:	89 c2                	mov    %eax,%edx
  for(fd = 0; fd < NOFILE; fd++){
80105aa1:	31 c0                	xor    %eax,%eax
80105aa3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80105aa8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105aaf:	00 
    if(curproc->ofile[fd] == 0){
80105ab0:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
80105ab4:	85 c9                	test   %ecx,%ecx
80105ab6:	74 38                	je     80105af0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105ab8:	83 c0 01             	add    $0x1,%eax
80105abb:	83 f8 10             	cmp    $0x10,%eax
80105abe:	75 f0                	jne    80105ab0 <sys_pipe+0x80>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105ac0:	e8 db e0 ff ff       	call   80103ba0 <myproc>
80105ac5:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105acc:	00 
    fileclose(rf);
80105acd:	83 ec 0c             	sub    $0xc,%esp
80105ad0:	ff 75 e0             	push   -0x20(%ebp)
80105ad3:	e8 a8 b4 ff ff       	call   80100f80 <fileclose>
    fileclose(wf);
80105ad8:	58                   	pop    %eax
80105ad9:	ff 75 e4             	push   -0x1c(%ebp)
80105adc:	e8 9f b4 ff ff       	call   80100f80 <fileclose>
    return -1;
80105ae1:	83 c4 10             	add    $0x10,%esp
    return -1;
80105ae4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae9:	eb 16                	jmp    80105b01 <sys_pipe+0xd1>
80105aeb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105af0:	89 7c 82 28          	mov    %edi,0x28(%edx,%eax,4)
  }
  fd[0] = fd0;
80105af4:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105af7:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80105af9:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105afc:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80105aff:	31 c0                	xor    %eax,%eax
}
80105b01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b04:	5b                   	pop    %ebx
80105b05:	5e                   	pop    %esi
80105b06:	5f                   	pop    %edi
80105b07:	5d                   	pop    %ebp
80105b08:	c3                   	ret
80105b09:	66 90                	xchg   %ax,%ax
80105b0b:	66 90                	xchg   %ax,%ax
80105b0d:	66 90                	xchg   %ax,%ax
80105b0f:	90                   	nop

80105b10 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105b10:	e9 2b e2 ff ff       	jmp    80103d40 <fork>
80105b15:	8d 76 00             	lea    0x0(%esi),%esi
80105b18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b1f:	00 

80105b20 <sys_exit>:
}

int
sys_exit(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	83 ec 08             	sub    $0x8,%esp
  exit();
80105b26:	e8 35 e5 ff ff       	call   80104060 <exit>
  return 0;  // not reached
}
80105b2b:	31 c0                	xor    %eax,%eax
80105b2d:	c9                   	leave
80105b2e:	c3                   	ret
80105b2f:	90                   	nop

80105b30 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105b30:	e9 9b e6 ff ff       	jmp    801041d0 <wait>
80105b35:	8d 76 00             	lea    0x0(%esi),%esi
80105b38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b3f:	00 

80105b40 <sys_kill>:
}

int
sys_kill(void)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105b46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b49:	50                   	push   %eax
80105b4a:	6a 00                	push   $0x0
80105b4c:	e8 7f f2 ff ff       	call   80104dd0 <argint>
80105b51:	83 c4 10             	add    $0x10,%esp
80105b54:	85 c0                	test   %eax,%eax
80105b56:	78 18                	js     80105b70 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105b58:	83 ec 0c             	sub    $0xc,%esp
80105b5b:	ff 75 f4             	push   -0xc(%ebp)
80105b5e:	e8 dd e9 ff ff       	call   80104540 <kill>
80105b63:	83 c4 10             	add    $0x10,%esp
}
80105b66:	c9                   	leave
80105b67:	c3                   	ret
80105b68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b6f:	00 
80105b70:	c9                   	leave
    return -1;
80105b71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b76:	c3                   	ret
80105b77:	90                   	nop
80105b78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b7f:	00 

80105b80 <sys_getpid>:

int
sys_getpid(void)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105b86:	e8 15 e0 ff ff       	call   80103ba0 <myproc>
80105b8b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105b8e:	c9                   	leave
80105b8f:	c3                   	ret

80105b90 <sys_sbrk>:

int
sys_sbrk(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105b94:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b97:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b9a:	50                   	push   %eax
80105b9b:	6a 00                	push   $0x0
80105b9d:	e8 2e f2 ff ff       	call   80104dd0 <argint>
80105ba2:	83 c4 10             	add    $0x10,%esp
80105ba5:	85 c0                	test   %eax,%eax
80105ba7:	78 27                	js     80105bd0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ba9:	e8 f2 df ff ff       	call   80103ba0 <myproc>
  if(growproc(n) < 0)
80105bae:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105bb1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105bb3:	ff 75 f4             	push   -0xc(%ebp)
80105bb6:	e8 05 e1 ff ff       	call   80103cc0 <growproc>
80105bbb:	83 c4 10             	add    $0x10,%esp
80105bbe:	85 c0                	test   %eax,%eax
80105bc0:	78 0e                	js     80105bd0 <sys_sbrk+0x40>
  addr = myproc()->sz;
80105bc2:	89 d8                	mov    %ebx,%eax
    return -1;
  return addr;
}
80105bc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bc7:	c9                   	leave
80105bc8:	c3                   	ret
80105bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd5:	eb ed                	jmp    80105bc4 <sys_sbrk+0x34>
80105bd7:	90                   	nop
80105bd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bdf:	00 

80105be0 <sys_sleep>:

int
sys_sleep(void)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
80105be3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105be4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105be7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105bea:	50                   	push   %eax
80105beb:	6a 00                	push   $0x0
80105bed:	e8 de f1 ff ff       	call   80104dd0 <argint>
80105bf2:	83 c4 10             	add    $0x10,%esp
80105bf5:	85 c0                	test   %eax,%eax
80105bf7:	78 64                	js     80105c5d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105bf9:	83 ec 0c             	sub    $0xc,%esp
80105bfc:	68 80 4e 11 80       	push   $0x80114e80
80105c01:	e8 da ed ff ff       	call   801049e0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105c06:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c09:	83 c4 10             	add    $0x10,%esp
80105c0c:	85 d2                	test   %edx,%edx
80105c0e:	74 58                	je     80105c68 <sys_sleep+0x88>
  ticks0 = ticks;
80105c10:	8b 1d 60 4e 11 80    	mov    0x80114e60,%ebx
80105c16:	eb 29                	jmp    80105c41 <sys_sleep+0x61>
80105c18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c1f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105c20:	83 ec 08             	sub    $0x8,%esp
80105c23:	68 80 4e 11 80       	push   $0x80114e80
80105c28:	68 60 4e 11 80       	push   $0x80114e60
80105c2d:	e8 ce e7 ff ff       	call   80104400 <sleep>
  while(ticks - ticks0 < n){
80105c32:	a1 60 4e 11 80       	mov    0x80114e60,%eax
80105c37:	83 c4 10             	add    $0x10,%esp
80105c3a:	29 d8                	sub    %ebx,%eax
80105c3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105c3f:	73 27                	jae    80105c68 <sys_sleep+0x88>
    if(myproc()->killed){
80105c41:	e8 5a df ff ff       	call   80103ba0 <myproc>
80105c46:	8b 40 24             	mov    0x24(%eax),%eax
80105c49:	85 c0                	test   %eax,%eax
80105c4b:	74 d3                	je     80105c20 <sys_sleep+0x40>
      release(&tickslock);
80105c4d:	83 ec 0c             	sub    $0xc,%esp
80105c50:	68 80 4e 11 80       	push   $0x80114e80
80105c55:	e8 26 ed ff ff       	call   80104980 <release>
      return -1;
80105c5a:	83 c4 10             	add    $0x10,%esp
    return -1;
80105c5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c62:	eb 16                	jmp    80105c7a <sys_sleep+0x9a>
80105c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  release(&tickslock);
80105c68:	83 ec 0c             	sub    $0xc,%esp
80105c6b:	68 80 4e 11 80       	push   $0x80114e80
80105c70:	e8 0b ed ff ff       	call   80104980 <release>
  return 0;
80105c75:	83 c4 10             	add    $0x10,%esp
80105c78:	31 c0                	xor    %eax,%eax
}
80105c7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c7d:	c9                   	leave
80105c7e:	c3                   	ret
80105c7f:	90                   	nop

80105c80 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	53                   	push   %ebx
80105c84:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105c87:	68 80 4e 11 80       	push   $0x80114e80
80105c8c:	e8 4f ed ff ff       	call   801049e0 <acquire>
  xticks = ticks;
80105c91:	8b 1d 60 4e 11 80    	mov    0x80114e60,%ebx
  release(&tickslock);
80105c97:	c7 04 24 80 4e 11 80 	movl   $0x80114e80,(%esp)
80105c9e:	e8 dd ec ff ff       	call   80104980 <release>
  return xticks;
}
80105ca3:	89 d8                	mov    %ebx,%eax
80105ca5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ca8:	c9                   	leave
80105ca9:	c3                   	ret
80105caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105cb0 <sys_settickets>:

int
sys_settickets(void)
{
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	83 ec 20             	sub    $0x20,%esp
  int n;
  if(argint(0, &n) < 0 || n < 1)
80105cb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cb9:	50                   	push   %eax
80105cba:	6a 00                	push   $0x0
80105cbc:	e8 0f f1 ff ff       	call   80104dd0 <argint>
80105cc1:	83 c4 10             	add    $0x10,%esp
80105cc4:	85 c0                	test   %eax,%eax
80105cc6:	78 18                	js     80105ce0 <sys_settickets+0x30>
80105cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ccb:	85 c0                	test   %eax,%eax
80105ccd:	7e 11                	jle    80105ce0 <sys_settickets+0x30>
    return -1;
  
  myproc()->tickets = n;
80105ccf:	e8 cc de ff ff       	call   80103ba0 <myproc>
80105cd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cd7:	89 50 7c             	mov    %edx,0x7c(%eax)
  return 0;
80105cda:	31 c0                	xor    %eax,%eax
}
80105cdc:	c9                   	leave
80105cdd:	c3                   	ret
80105cde:	66 90                	xchg   %ax,%ax
80105ce0:	c9                   	leave
    return -1;
80105ce1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ce6:	c3                   	ret

80105ce7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105ce7:	1e                   	push   %ds
  pushl %es
80105ce8:	06                   	push   %es
  pushl %fs
80105ce9:	0f a0                	push   %fs
  pushl %gs
80105ceb:	0f a8                	push   %gs
  pushal
80105ced:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105cee:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105cf2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105cf4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105cf6:	54                   	push   %esp
  call trap
80105cf7:	e8 24 01 00 00       	call   80105e20 <trap>
  addl $4, %esp
80105cfc:	83 c4 04             	add    $0x4,%esp

80105cff <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105cff:	61                   	popa
  popl %gs
80105d00:	0f a9                	pop    %gs
  popl %fs
80105d02:	0f a1                	pop    %fs
  popl %es
80105d04:	07                   	pop    %es
  popl %ds
80105d05:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105d06:	83 c4 08             	add    $0x8,%esp
  iret
80105d09:	cf                   	iret
80105d0a:	66 90                	xchg   %ax,%ax
80105d0c:	66 90                	xchg   %ax,%ax
80105d0e:	66 90                	xchg   %ax,%ax
80105d10:	66 90                	xchg   %ax,%ax
80105d12:	66 90                	xchg   %ax,%ax
80105d14:	66 90                	xchg   %ax,%ax
80105d16:	66 90                	xchg   %ax,%ax
80105d18:	66 90                	xchg   %ax,%ax
80105d1a:	66 90                	xchg   %ax,%ax
80105d1c:	66 90                	xchg   %ax,%ax
80105d1e:	66 90                	xchg   %ax,%ax
80105d20:	66 90                	xchg   %ax,%ax
80105d22:	66 90                	xchg   %ax,%ax
80105d24:	66 90                	xchg   %ax,%ax
80105d26:	66 90                	xchg   %ax,%ax
80105d28:	66 90                	xchg   %ax,%ax
80105d2a:	66 90                	xchg   %ax,%ax
80105d2c:	66 90                	xchg   %ax,%ax
80105d2e:	66 90                	xchg   %ax,%ax
80105d30:	66 90                	xchg   %ax,%ax
80105d32:	66 90                	xchg   %ax,%ax
80105d34:	66 90                	xchg   %ax,%ax
80105d36:	66 90                	xchg   %ax,%ax
80105d38:	66 90                	xchg   %ax,%ax
80105d3a:	66 90                	xchg   %ax,%ax
80105d3c:	66 90                	xchg   %ax,%ax
80105d3e:	66 90                	xchg   %ax,%ax

80105d40 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105d40:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105d41:	31 c0                	xor    %eax,%eax
{
80105d43:	89 e5                	mov    %esp,%ebp
80105d45:	83 ec 08             	sub    $0x8,%esp
80105d48:	eb 36                	jmp    80105d80 <tvinit+0x40>
80105d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d50:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d57:	00 
80105d58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d5f:	00 
80105d60:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d67:	00 
80105d68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d6f:	00 
80105d70:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d77:	00 
80105d78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d7f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d80:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80105d87:	c7 04 c5 c2 4e 11 80 	movl   $0x8e000008,-0x7feeb13e(,%eax,8)
80105d8e:	08 00 00 8e 
80105d92:	66 89 14 c5 c0 4e 11 	mov    %dx,-0x7feeb140(,%eax,8)
80105d99:	80 
80105d9a:	c1 ea 10             	shr    $0x10,%edx
80105d9d:	66 89 14 c5 c6 4e 11 	mov    %dx,-0x7feeb13a(,%eax,8)
80105da4:	80 
  for(i = 0; i < 256; i++)
80105da5:	83 c0 01             	add    $0x1,%eax
80105da8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105dad:	75 d1                	jne    80105d80 <tvinit+0x40>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105daf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105db2:	a1 0c b1 10 80       	mov    0x8010b10c,%eax
80105db7:	c7 05 c2 50 11 80 08 	movl   $0xef000008,0x801150c2
80105dbe:	00 00 ef 
  initlock(&tickslock, "time");
80105dc1:	68 ce 7a 10 80       	push   $0x80107ace
80105dc6:	68 80 4e 11 80       	push   $0x80114e80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105dcb:	66 a3 c0 50 11 80    	mov    %ax,0x801150c0
80105dd1:	c1 e8 10             	shr    $0x10,%eax
80105dd4:	66 a3 c6 50 11 80    	mov    %ax,0x801150c6
  initlock(&tickslock, "time");
80105dda:	e8 e1 e9 ff ff       	call   801047c0 <initlock>
}
80105ddf:	83 c4 10             	add    $0x10,%esp
80105de2:	c9                   	leave
80105de3:	c3                   	ret
80105de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105de8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105def:	00 

80105df0 <idtinit>:

void
idtinit(void)
{
80105df0:	55                   	push   %ebp
  pd[0] = size-1;
80105df1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105df6:	89 e5                	mov    %esp,%ebp
80105df8:	83 ec 10             	sub    $0x10,%esp
80105dfb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105dff:	b8 c0 4e 11 80       	mov    $0x80114ec0,%eax
80105e04:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105e08:	c1 e8 10             	shr    $0x10,%eax
80105e0b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105e0f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105e12:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105e15:	c9                   	leave
80105e16:	c3                   	ret
80105e17:	90                   	nop
80105e18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e1f:	00 

80105e20 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105e20:	55                   	push   %ebp
80105e21:	89 e5                	mov    %esp,%ebp
80105e23:	57                   	push   %edi
80105e24:	56                   	push   %esi
80105e25:	53                   	push   %ebx
80105e26:	83 ec 1c             	sub    $0x1c,%esp
80105e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105e2c:	8b 43 30             	mov    0x30(%ebx),%eax
80105e2f:	83 f8 40             	cmp    $0x40,%eax
80105e32:	0f 84 78 01 00 00    	je     80105fb0 <trap+0x190>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105e38:	83 e8 20             	sub    $0x20,%eax
80105e3b:	83 f8 1f             	cmp    $0x1f,%eax
80105e3e:	0f 87 7c 00 00 00    	ja     80105ec0 <trap+0xa0>
80105e44:	ff 24 85 38 80 10 80 	jmp    *-0x7fef7fc8(,%eax,4)
80105e4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      
      yield();
    }
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105e50:	e8 cb c4 ff ff       	call   80102320 <ideintr>
    lapiceoi();
80105e55:	e8 c6 cb ff ff       	call   80102a20 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e5a:	e8 41 dd ff ff       	call   80103ba0 <myproc>
80105e5f:	85 c0                	test   %eax,%eax
80105e61:	74 1a                	je     80105e7d <trap+0x5d>
80105e63:	e8 38 dd ff ff       	call   80103ba0 <myproc>
80105e68:	8b 50 24             	mov    0x24(%eax),%edx
80105e6b:	85 d2                	test   %edx,%edx
80105e6d:	74 0e                	je     80105e7d <trap+0x5d>
80105e6f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e73:	f7 d0                	not    %eax
80105e75:	a8 03                	test   $0x3,%al
80105e77:	0f 84 13 02 00 00    	je     80106090 <trap+0x270>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105e7d:	e8 1e dd ff ff       	call   80103ba0 <myproc>
80105e82:	85 c0                	test   %eax,%eax
80105e84:	74 0f                	je     80105e95 <trap+0x75>
80105e86:	e8 15 dd ff ff       	call   80103ba0 <myproc>
80105e8b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105e8f:	0f 84 ab 00 00 00    	je     80105f40 <trap+0x120>
      myproc()->tickets--;
    yield();
  }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e95:	e8 06 dd ff ff       	call   80103ba0 <myproc>
80105e9a:	85 c0                	test   %eax,%eax
80105e9c:	74 1a                	je     80105eb8 <trap+0x98>
80105e9e:	e8 fd dc ff ff       	call   80103ba0 <myproc>
80105ea3:	8b 40 24             	mov    0x24(%eax),%eax
80105ea6:	85 c0                	test   %eax,%eax
80105ea8:	74 0e                	je     80105eb8 <trap+0x98>
80105eaa:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105eae:	f7 d0                	not    %eax
80105eb0:	a8 03                	test   $0x3,%al
80105eb2:	0f 84 25 01 00 00    	je     80105fdd <trap+0x1bd>
    exit();
}
80105eb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ebb:	5b                   	pop    %ebx
80105ebc:	5e                   	pop    %esi
80105ebd:	5f                   	pop    %edi
80105ebe:	5d                   	pop    %ebp
80105ebf:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80105ec0:	e8 db dc ff ff       	call   80103ba0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ec5:	8b 73 38             	mov    0x38(%ebx),%esi
80105ec8:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    if(myproc() == 0 || (tf->cs&3) == 0){
80105ecb:	85 c0                	test   %eax,%eax
80105ecd:	0f 84 0f 02 00 00    	je     801060e2 <trap+0x2c2>
80105ed3:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105ed7:	0f 84 05 02 00 00    	je     801060e2 <trap+0x2c2>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105edd:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ee0:	e8 9b dc ff ff       	call   80103b80 <cpuid>
80105ee5:	8b 4b 30             	mov    0x30(%ebx),%ecx
80105ee8:	89 45 d8             	mov    %eax,-0x28(%ebp)
80105eeb:	8b 43 34             	mov    0x34(%ebx),%eax
80105eee:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80105ef1:	89 45 e0             	mov    %eax,-0x20(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105ef4:	e8 a7 dc ff ff       	call   80103ba0 <myproc>
80105ef9:	8d 70 6c             	lea    0x6c(%eax),%esi
80105efc:	e8 9f dc ff ff       	call   80103ba0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f01:	57                   	push   %edi
80105f02:	ff 75 e4             	push   -0x1c(%ebp)
80105f05:	8b 55 d8             	mov    -0x28(%ebp),%edx
80105f08:	52                   	push   %edx
80105f09:	ff 75 e0             	push   -0x20(%ebp)
80105f0c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80105f0f:	51                   	push   %ecx
80105f10:	56                   	push   %esi
80105f11:	ff 70 10             	push   0x10(%eax)
80105f14:	68 1c 7d 10 80       	push   $0x80107d1c
80105f19:	e8 b2 a7 ff ff       	call   801006d0 <cprintf>
    myproc()->killed = 1;
80105f1e:	83 c4 20             	add    $0x20,%esp
80105f21:	e8 7a dc ff ff       	call   80103ba0 <myproc>
80105f26:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f2d:	e8 6e dc ff ff       	call   80103ba0 <myproc>
80105f32:	85 c0                	test   %eax,%eax
80105f34:	0f 85 29 ff ff ff    	jne    80105e63 <trap+0x43>
80105f3a:	e9 3e ff ff ff       	jmp    80105e7d <trap+0x5d>
80105f3f:	90                   	nop
  if(myproc() && myproc()->state == RUNNING &&
80105f40:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105f44:	0f 85 4b ff ff ff    	jne    80105e95 <trap+0x75>
    if(myproc()->tickets > MIN_TICKETS)
80105f4a:	e8 51 dc ff ff       	call   80103ba0 <myproc>
80105f4f:	83 78 7c 01          	cmpl   $0x1,0x7c(%eax)
80105f53:	7e 09                	jle    80105f5e <trap+0x13e>
      myproc()->tickets--;
80105f55:	e8 46 dc ff ff       	call   80103ba0 <myproc>
80105f5a:	83 68 7c 01          	subl   $0x1,0x7c(%eax)
    yield();
80105f5e:	e8 cd e3 ff ff       	call   80104330 <yield>
80105f63:	e9 2d ff ff ff       	jmp    80105e95 <trap+0x75>
80105f68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105f6f:	00 
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105f70:	8b 4b 38             	mov    0x38(%ebx),%ecx
80105f73:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
80105f77:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80105f7a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80105f7d:	e8 fe db ff ff       	call   80103b80 <cpuid>
80105f82:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80105f85:	51                   	push   %ecx
80105f86:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105f89:	52                   	push   %edx
80105f8a:	50                   	push   %eax
80105f8b:	68 c4 7c 10 80       	push   $0x80107cc4
80105f90:	e8 3b a7 ff ff       	call   801006d0 <cprintf>
    lapiceoi();
80105f95:	e8 86 ca ff ff       	call   80102a20 <lapiceoi>
    break;
80105f9a:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f9d:	e8 fe db ff ff       	call   80103ba0 <myproc>
80105fa2:	85 c0                	test   %eax,%eax
80105fa4:	0f 85 b9 fe ff ff    	jne    80105e63 <trap+0x43>
80105faa:	e9 ce fe ff ff       	jmp    80105e7d <trap+0x5d>
80105faf:	90                   	nop
    if(myproc()->killed)
80105fb0:	e8 eb db ff ff       	call   80103ba0 <myproc>
80105fb5:	8b 70 24             	mov    0x24(%eax),%esi
80105fb8:	85 f6                	test   %esi,%esi
80105fba:	0f 85 18 01 00 00    	jne    801060d8 <trap+0x2b8>
    myproc()->tf = tf;
80105fc0:	e8 db db ff ff       	call   80103ba0 <myproc>
80105fc5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105fc8:	e8 43 ef ff ff       	call   80104f10 <syscall>
    if(myproc()->killed)
80105fcd:	e8 ce db ff ff       	call   80103ba0 <myproc>
80105fd2:	8b 48 24             	mov    0x24(%eax),%ecx
80105fd5:	85 c9                	test   %ecx,%ecx
80105fd7:	0f 84 db fe ff ff    	je     80105eb8 <trap+0x98>
}
80105fdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fe0:	5b                   	pop    %ebx
80105fe1:	5e                   	pop    %esi
80105fe2:	5f                   	pop    %edi
80105fe3:	5d                   	pop    %ebp
      exit();
80105fe4:	e9 77 e0 ff ff       	jmp    80104060 <exit>
80105fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105ff0:	e8 9b 02 00 00       	call   80106290 <uartintr>
    lapiceoi();
80105ff5:	e8 26 ca ff ff       	call   80102a20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ffa:	e8 a1 db ff ff       	call   80103ba0 <myproc>
80105fff:	85 c0                	test   %eax,%eax
80106001:	0f 85 5c fe ff ff    	jne    80105e63 <trap+0x43>
80106007:	e9 71 fe ff ff       	jmp    80105e7d <trap+0x5d>
8010600c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106010:	e8 cb c8 ff ff       	call   801028e0 <kbdintr>
    lapiceoi();
80106015:	e8 06 ca ff ff       	call   80102a20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010601a:	e8 81 db ff ff       	call   80103ba0 <myproc>
8010601f:	85 c0                	test   %eax,%eax
80106021:	0f 85 3c fe ff ff    	jne    80105e63 <trap+0x43>
80106027:	e9 51 fe ff ff       	jmp    80105e7d <trap+0x5d>
8010602c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106030:	e8 4b db ff ff       	call   80103b80 <cpuid>
80106035:	85 c0                	test   %eax,%eax
80106037:	74 67                	je     801060a0 <trap+0x280>
    lapiceoi();
80106039:	e8 e2 c9 ff ff       	call   80102a20 <lapiceoi>
    if(myproc() && myproc()->state == RUNNING) {
8010603e:	e8 5d db ff ff       	call   80103ba0 <myproc>
80106043:	85 c0                	test   %eax,%eax
80106045:	0f 84 0f fe ff ff    	je     80105e5a <trap+0x3a>
8010604b:	e8 50 db ff ff       	call   80103ba0 <myproc>
80106050:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106054:	0f 85 00 fe ff ff    	jne    80105e5a <trap+0x3a>
      if(myproc()->tickets > 1) {
8010605a:	e8 41 db ff ff       	call   80103ba0 <myproc>
8010605f:	83 78 7c 01          	cmpl   $0x1,0x7c(%eax)
80106063:	7e 09                	jle    8010606e <trap+0x24e>
        myproc()->tickets--;
80106065:	e8 36 db ff ff       	call   80103ba0 <myproc>
8010606a:	83 68 7c 01          	subl   $0x1,0x7c(%eax)
      myproc()->pushed = 1; 
8010606e:	e8 2d db ff ff       	call   80103ba0 <myproc>
80106073:	c7 80 80 00 00 00 01 	movl   $0x1,0x80(%eax)
8010607a:	00 00 00 
      yield();
8010607d:	e8 ae e2 ff ff       	call   80104330 <yield>
80106082:	e9 d3 fd ff ff       	jmp    80105e5a <trap+0x3a>
80106087:	90                   	nop
80106088:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010608f:	00 
    exit();
80106090:	e8 cb df ff ff       	call   80104060 <exit>
80106095:	e9 e3 fd ff ff       	jmp    80105e7d <trap+0x5d>
8010609a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
801060a0:	83 ec 0c             	sub    $0xc,%esp
801060a3:	68 80 4e 11 80       	push   $0x80114e80
801060a8:	e8 33 e9 ff ff       	call   801049e0 <acquire>
      ticks++;
801060ad:	83 05 60 4e 11 80 01 	addl   $0x1,0x80114e60
      wakeup(&ticks);
801060b4:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
801060bb:	e8 20 e4 ff ff       	call   801044e0 <wakeup>
      release(&tickslock);
801060c0:	c7 04 24 80 4e 11 80 	movl   $0x80114e80,(%esp)
801060c7:	e8 b4 e8 ff ff       	call   80104980 <release>
801060cc:	83 c4 10             	add    $0x10,%esp
801060cf:	e9 65 ff ff ff       	jmp    80106039 <trap+0x219>
801060d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      exit();
801060d8:	e8 83 df ff ff       	call   80104060 <exit>
801060dd:	e9 de fe ff ff       	jmp    80105fc0 <trap+0x1a0>
801060e2:	0f 20 d2             	mov    %cr2,%edx
801060e5:	89 55 e0             	mov    %edx,-0x20(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801060e8:	e8 93 da ff ff       	call   80103b80 <cpuid>
801060ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
801060f0:	83 ec 0c             	sub    $0xc,%esp
801060f3:	52                   	push   %edx
801060f4:	ff 75 e4             	push   -0x1c(%ebp)
801060f7:	50                   	push   %eax
801060f8:	ff 73 30             	push   0x30(%ebx)
801060fb:	68 e8 7c 10 80       	push   $0x80107ce8
80106100:	e8 cb a5 ff ff       	call   801006d0 <cprintf>
      panic("trap");
80106105:	83 c4 14             	add    $0x14,%esp
80106108:	68 d3 7a 10 80       	push   $0x80107ad3
8010610d:	e8 8e a2 ff ff       	call   801003a0 <panic>
80106112:	66 90                	xchg   %ax,%ax
80106114:	66 90                	xchg   %ax,%ax
80106116:	66 90                	xchg   %ax,%ax
80106118:	66 90                	xchg   %ax,%ax
8010611a:	66 90                	xchg   %ax,%ax
8010611c:	66 90                	xchg   %ax,%ax
8010611e:	66 90                	xchg   %ax,%ax

80106120 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106120:	a1 c0 56 11 80       	mov    0x801156c0,%eax
80106125:	85 c0                	test   %eax,%eax
80106127:	74 17                	je     80106140 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106129:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010612e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010612f:	a8 01                	test   $0x1,%al
80106131:	74 0d                	je     80106140 <uartgetc+0x20>
80106133:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106138:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106139:	0f b6 c0             	movzbl %al,%eax
8010613c:	c3                   	ret
8010613d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106145:	c3                   	ret
80106146:	66 90                	xchg   %ax,%ax
80106148:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010614f:	00 

80106150 <uartinit>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106150:	31 c0                	xor    %eax,%eax
80106152:	ba fa 03 00 00       	mov    $0x3fa,%edx
80106157:	ee                   	out    %al,(%dx)
80106158:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010615d:	ba fb 03 00 00       	mov    $0x3fb,%edx
80106162:	ee                   	out    %al,(%dx)
80106163:	b8 0c 00 00 00       	mov    $0xc,%eax
80106168:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010616d:	ee                   	out    %al,(%dx)
8010616e:	31 c0                	xor    %eax,%eax
80106170:	ba f9 03 00 00       	mov    $0x3f9,%edx
80106175:	ee                   	out    %al,(%dx)
80106176:	b8 03 00 00 00       	mov    $0x3,%eax
8010617b:	ba fb 03 00 00       	mov    $0x3fb,%edx
80106180:	ee                   	out    %al,(%dx)
80106181:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106186:	31 c0                	xor    %eax,%eax
80106188:	ee                   	out    %al,(%dx)
80106189:	b8 01 00 00 00       	mov    $0x1,%eax
8010618e:	ba f9 03 00 00       	mov    $0x3f9,%edx
80106193:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106194:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106199:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
8010619a:	3c ff                	cmp    $0xff,%al
8010619c:	0f 84 8e 00 00 00    	je     80106230 <uartinit+0xe0>
{
801061a2:	55                   	push   %ebp
801061a3:	ba fa 03 00 00       	mov    $0x3fa,%edx
801061a8:	89 e5                	mov    %esp,%ebp
801061aa:	57                   	push   %edi
801061ab:	56                   	push   %esi
801061ac:	53                   	push   %ebx
801061ad:	83 ec 24             	sub    $0x24,%esp
  uart = 1;
801061b0:	c7 05 c0 56 11 80 01 	movl   $0x1,0x801156c0
801061b7:	00 00 00 
801061ba:	ec                   	in     (%dx),%al
801061bb:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061c0:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801061c1:	6a 00                	push   $0x0
  for(p="xv6...\n"; *p; p++)
801061c3:	bf d8 7a 10 80       	mov    $0x80107ad8,%edi
  ioapicenable(IRQ_COM1, 0);
801061c8:	6a 04                	push   $0x4
801061ca:	e8 b1 c3 ff ff       	call   80102580 <ioapicenable>
801061cf:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801061d2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
801061d6:	66 90                	xchg   %ax,%ax
801061d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801061df:	00 
  if(!uart)
801061e0:	a1 c0 56 11 80       	mov    0x801156c0,%eax
801061e5:	bb 80 00 00 00       	mov    $0x80,%ebx
801061ea:	85 c0                	test   %eax,%eax
801061ec:	75 14                	jne    80106202 <uartinit+0xb2>
801061ee:	eb 26                	jmp    80106216 <uartinit+0xc6>
    microdelay(10);
801061f0:	83 ec 0c             	sub    $0xc,%esp
801061f3:	6a 0a                	push   $0xa
801061f5:	e8 46 c8 ff ff       	call   80102a40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061fa:	83 c4 10             	add    $0x10,%esp
801061fd:	83 eb 01             	sub    $0x1,%ebx
80106200:	74 0a                	je     8010620c <uartinit+0xbc>
80106202:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106207:	ec                   	in     (%dx),%al
80106208:	a8 20                	test   $0x20,%al
8010620a:	74 e4                	je     801061f0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010620c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80106210:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106215:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106216:	0f b6 47 01          	movzbl 0x1(%edi),%eax
8010621a:	83 c7 01             	add    $0x1,%edi
8010621d:	88 45 e7             	mov    %al,-0x19(%ebp)
80106220:	81 ff df 7a 10 80    	cmp    $0x80107adf,%edi
80106226:	75 b8                	jne    801061e0 <uartinit+0x90>
}
80106228:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010622b:	5b                   	pop    %ebx
8010622c:	5e                   	pop    %esi
8010622d:	5f                   	pop    %edi
8010622e:	5d                   	pop    %ebp
8010622f:	c3                   	ret
80106230:	c3                   	ret
80106231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106238:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010623f:	00 

80106240 <uartputc>:
  if(!uart)
80106240:	a1 c0 56 11 80       	mov    0x801156c0,%eax
80106245:	85 c0                	test   %eax,%eax
80106247:	74 3f                	je     80106288 <uartputc+0x48>
{
80106249:	55                   	push   %ebp
8010624a:	89 e5                	mov    %esp,%ebp
8010624c:	56                   	push   %esi
8010624d:	53                   	push   %ebx
8010624e:	bb 80 00 00 00       	mov    $0x80,%ebx
80106253:	eb 15                	jmp    8010626a <uartputc+0x2a>
80106255:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80106258:	83 ec 0c             	sub    $0xc,%esp
8010625b:	6a 0a                	push   $0xa
8010625d:	e8 de c7 ff ff       	call   80102a40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106262:	83 c4 10             	add    $0x10,%esp
80106265:	83 eb 01             	sub    $0x1,%ebx
80106268:	74 0a                	je     80106274 <uartputc+0x34>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010626a:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010626f:	ec                   	in     (%dx),%al
80106270:	a8 20                	test   $0x20,%al
80106272:	74 e4                	je     80106258 <uartputc+0x18>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106274:	8b 45 08             	mov    0x8(%ebp),%eax
80106277:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010627c:	ee                   	out    %al,(%dx)
}
8010627d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106280:	5b                   	pop    %ebx
80106281:	5e                   	pop    %esi
80106282:	5d                   	pop    %ebp
80106283:	c3                   	ret
80106284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106288:	c3                   	ret
80106289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106290 <uartintr>:

void
uartintr(void)
{
80106290:	55                   	push   %ebp
80106291:	89 e5                	mov    %esp,%ebp
80106293:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106296:	68 20 61 10 80       	push   $0x80106120
8010629b:	e8 30 a6 ff ff       	call   801008d0 <consoleintr>
}
801062a0:	83 c4 10             	add    $0x10,%esp
801062a3:	c9                   	leave
801062a4:	c3                   	ret

801062a5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801062a5:	6a 00                	push   $0x0
  pushl $0
801062a7:	6a 00                	push   $0x0
  jmp alltraps
801062a9:	e9 39 fa ff ff       	jmp    80105ce7 <alltraps>

801062ae <vector1>:
.globl vector1
vector1:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $1
801062b0:	6a 01                	push   $0x1
  jmp alltraps
801062b2:	e9 30 fa ff ff       	jmp    80105ce7 <alltraps>

801062b7 <vector2>:
.globl vector2
vector2:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $2
801062b9:	6a 02                	push   $0x2
  jmp alltraps
801062bb:	e9 27 fa ff ff       	jmp    80105ce7 <alltraps>

801062c0 <vector3>:
.globl vector3
vector3:
  pushl $0
801062c0:	6a 00                	push   $0x0
  pushl $3
801062c2:	6a 03                	push   $0x3
  jmp alltraps
801062c4:	e9 1e fa ff ff       	jmp    80105ce7 <alltraps>

801062c9 <vector4>:
.globl vector4
vector4:
  pushl $0
801062c9:	6a 00                	push   $0x0
  pushl $4
801062cb:	6a 04                	push   $0x4
  jmp alltraps
801062cd:	e9 15 fa ff ff       	jmp    80105ce7 <alltraps>

801062d2 <vector5>:
.globl vector5
vector5:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $5
801062d4:	6a 05                	push   $0x5
  jmp alltraps
801062d6:	e9 0c fa ff ff       	jmp    80105ce7 <alltraps>

801062db <vector6>:
.globl vector6
vector6:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $6
801062dd:	6a 06                	push   $0x6
  jmp alltraps
801062df:	e9 03 fa ff ff       	jmp    80105ce7 <alltraps>

801062e4 <vector7>:
.globl vector7
vector7:
  pushl $0
801062e4:	6a 00                	push   $0x0
  pushl $7
801062e6:	6a 07                	push   $0x7
  jmp alltraps
801062e8:	e9 fa f9 ff ff       	jmp    80105ce7 <alltraps>

801062ed <vector8>:
.globl vector8
vector8:
  pushl $8
801062ed:	6a 08                	push   $0x8
  jmp alltraps
801062ef:	e9 f3 f9 ff ff       	jmp    80105ce7 <alltraps>

801062f4 <vector9>:
.globl vector9
vector9:
  pushl $0
801062f4:	6a 00                	push   $0x0
  pushl $9
801062f6:	6a 09                	push   $0x9
  jmp alltraps
801062f8:	e9 ea f9 ff ff       	jmp    80105ce7 <alltraps>

801062fd <vector10>:
.globl vector10
vector10:
  pushl $10
801062fd:	6a 0a                	push   $0xa
  jmp alltraps
801062ff:	e9 e3 f9 ff ff       	jmp    80105ce7 <alltraps>

80106304 <vector11>:
.globl vector11
vector11:
  pushl $11
80106304:	6a 0b                	push   $0xb
  jmp alltraps
80106306:	e9 dc f9 ff ff       	jmp    80105ce7 <alltraps>

8010630b <vector12>:
.globl vector12
vector12:
  pushl $12
8010630b:	6a 0c                	push   $0xc
  jmp alltraps
8010630d:	e9 d5 f9 ff ff       	jmp    80105ce7 <alltraps>

80106312 <vector13>:
.globl vector13
vector13:
  pushl $13
80106312:	6a 0d                	push   $0xd
  jmp alltraps
80106314:	e9 ce f9 ff ff       	jmp    80105ce7 <alltraps>

80106319 <vector14>:
.globl vector14
vector14:
  pushl $14
80106319:	6a 0e                	push   $0xe
  jmp alltraps
8010631b:	e9 c7 f9 ff ff       	jmp    80105ce7 <alltraps>

80106320 <vector15>:
.globl vector15
vector15:
  pushl $0
80106320:	6a 00                	push   $0x0
  pushl $15
80106322:	6a 0f                	push   $0xf
  jmp alltraps
80106324:	e9 be f9 ff ff       	jmp    80105ce7 <alltraps>

80106329 <vector16>:
.globl vector16
vector16:
  pushl $0
80106329:	6a 00                	push   $0x0
  pushl $16
8010632b:	6a 10                	push   $0x10
  jmp alltraps
8010632d:	e9 b5 f9 ff ff       	jmp    80105ce7 <alltraps>

80106332 <vector17>:
.globl vector17
vector17:
  pushl $17
80106332:	6a 11                	push   $0x11
  jmp alltraps
80106334:	e9 ae f9 ff ff       	jmp    80105ce7 <alltraps>

80106339 <vector18>:
.globl vector18
vector18:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $18
8010633b:	6a 12                	push   $0x12
  jmp alltraps
8010633d:	e9 a5 f9 ff ff       	jmp    80105ce7 <alltraps>

80106342 <vector19>:
.globl vector19
vector19:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $19
80106344:	6a 13                	push   $0x13
  jmp alltraps
80106346:	e9 9c f9 ff ff       	jmp    80105ce7 <alltraps>

8010634b <vector20>:
.globl vector20
vector20:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $20
8010634d:	6a 14                	push   $0x14
  jmp alltraps
8010634f:	e9 93 f9 ff ff       	jmp    80105ce7 <alltraps>

80106354 <vector21>:
.globl vector21
vector21:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $21
80106356:	6a 15                	push   $0x15
  jmp alltraps
80106358:	e9 8a f9 ff ff       	jmp    80105ce7 <alltraps>

8010635d <vector22>:
.globl vector22
vector22:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $22
8010635f:	6a 16                	push   $0x16
  jmp alltraps
80106361:	e9 81 f9 ff ff       	jmp    80105ce7 <alltraps>

80106366 <vector23>:
.globl vector23
vector23:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $23
80106368:	6a 17                	push   $0x17
  jmp alltraps
8010636a:	e9 78 f9 ff ff       	jmp    80105ce7 <alltraps>

8010636f <vector24>:
.globl vector24
vector24:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $24
80106371:	6a 18                	push   $0x18
  jmp alltraps
80106373:	e9 6f f9 ff ff       	jmp    80105ce7 <alltraps>

80106378 <vector25>:
.globl vector25
vector25:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $25
8010637a:	6a 19                	push   $0x19
  jmp alltraps
8010637c:	e9 66 f9 ff ff       	jmp    80105ce7 <alltraps>

80106381 <vector26>:
.globl vector26
vector26:
  pushl $0
80106381:	6a 00                	push   $0x0
  pushl $26
80106383:	6a 1a                	push   $0x1a
  jmp alltraps
80106385:	e9 5d f9 ff ff       	jmp    80105ce7 <alltraps>

8010638a <vector27>:
.globl vector27
vector27:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $27
8010638c:	6a 1b                	push   $0x1b
  jmp alltraps
8010638e:	e9 54 f9 ff ff       	jmp    80105ce7 <alltraps>

80106393 <vector28>:
.globl vector28
vector28:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $28
80106395:	6a 1c                	push   $0x1c
  jmp alltraps
80106397:	e9 4b f9 ff ff       	jmp    80105ce7 <alltraps>

8010639c <vector29>:
.globl vector29
vector29:
  pushl $0
8010639c:	6a 00                	push   $0x0
  pushl $29
8010639e:	6a 1d                	push   $0x1d
  jmp alltraps
801063a0:	e9 42 f9 ff ff       	jmp    80105ce7 <alltraps>

801063a5 <vector30>:
.globl vector30
vector30:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $30
801063a7:	6a 1e                	push   $0x1e
  jmp alltraps
801063a9:	e9 39 f9 ff ff       	jmp    80105ce7 <alltraps>

801063ae <vector31>:
.globl vector31
vector31:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $31
801063b0:	6a 1f                	push   $0x1f
  jmp alltraps
801063b2:	e9 30 f9 ff ff       	jmp    80105ce7 <alltraps>

801063b7 <vector32>:
.globl vector32
vector32:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $32
801063b9:	6a 20                	push   $0x20
  jmp alltraps
801063bb:	e9 27 f9 ff ff       	jmp    80105ce7 <alltraps>

801063c0 <vector33>:
.globl vector33
vector33:
  pushl $0
801063c0:	6a 00                	push   $0x0
  pushl $33
801063c2:	6a 21                	push   $0x21
  jmp alltraps
801063c4:	e9 1e f9 ff ff       	jmp    80105ce7 <alltraps>

801063c9 <vector34>:
.globl vector34
vector34:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $34
801063cb:	6a 22                	push   $0x22
  jmp alltraps
801063cd:	e9 15 f9 ff ff       	jmp    80105ce7 <alltraps>

801063d2 <vector35>:
.globl vector35
vector35:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $35
801063d4:	6a 23                	push   $0x23
  jmp alltraps
801063d6:	e9 0c f9 ff ff       	jmp    80105ce7 <alltraps>

801063db <vector36>:
.globl vector36
vector36:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $36
801063dd:	6a 24                	push   $0x24
  jmp alltraps
801063df:	e9 03 f9 ff ff       	jmp    80105ce7 <alltraps>

801063e4 <vector37>:
.globl vector37
vector37:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $37
801063e6:	6a 25                	push   $0x25
  jmp alltraps
801063e8:	e9 fa f8 ff ff       	jmp    80105ce7 <alltraps>

801063ed <vector38>:
.globl vector38
vector38:
  pushl $0
801063ed:	6a 00                	push   $0x0
  pushl $38
801063ef:	6a 26                	push   $0x26
  jmp alltraps
801063f1:	e9 f1 f8 ff ff       	jmp    80105ce7 <alltraps>

801063f6 <vector39>:
.globl vector39
vector39:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $39
801063f8:	6a 27                	push   $0x27
  jmp alltraps
801063fa:	e9 e8 f8 ff ff       	jmp    80105ce7 <alltraps>

801063ff <vector40>:
.globl vector40
vector40:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $40
80106401:	6a 28                	push   $0x28
  jmp alltraps
80106403:	e9 df f8 ff ff       	jmp    80105ce7 <alltraps>

80106408 <vector41>:
.globl vector41
vector41:
  pushl $0
80106408:	6a 00                	push   $0x0
  pushl $41
8010640a:	6a 29                	push   $0x29
  jmp alltraps
8010640c:	e9 d6 f8 ff ff       	jmp    80105ce7 <alltraps>

80106411 <vector42>:
.globl vector42
vector42:
  pushl $0
80106411:	6a 00                	push   $0x0
  pushl $42
80106413:	6a 2a                	push   $0x2a
  jmp alltraps
80106415:	e9 cd f8 ff ff       	jmp    80105ce7 <alltraps>

8010641a <vector43>:
.globl vector43
vector43:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $43
8010641c:	6a 2b                	push   $0x2b
  jmp alltraps
8010641e:	e9 c4 f8 ff ff       	jmp    80105ce7 <alltraps>

80106423 <vector44>:
.globl vector44
vector44:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $44
80106425:	6a 2c                	push   $0x2c
  jmp alltraps
80106427:	e9 bb f8 ff ff       	jmp    80105ce7 <alltraps>

8010642c <vector45>:
.globl vector45
vector45:
  pushl $0
8010642c:	6a 00                	push   $0x0
  pushl $45
8010642e:	6a 2d                	push   $0x2d
  jmp alltraps
80106430:	e9 b2 f8 ff ff       	jmp    80105ce7 <alltraps>

80106435 <vector46>:
.globl vector46
vector46:
  pushl $0
80106435:	6a 00                	push   $0x0
  pushl $46
80106437:	6a 2e                	push   $0x2e
  jmp alltraps
80106439:	e9 a9 f8 ff ff       	jmp    80105ce7 <alltraps>

8010643e <vector47>:
.globl vector47
vector47:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $47
80106440:	6a 2f                	push   $0x2f
  jmp alltraps
80106442:	e9 a0 f8 ff ff       	jmp    80105ce7 <alltraps>

80106447 <vector48>:
.globl vector48
vector48:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $48
80106449:	6a 30                	push   $0x30
  jmp alltraps
8010644b:	e9 97 f8 ff ff       	jmp    80105ce7 <alltraps>

80106450 <vector49>:
.globl vector49
vector49:
  pushl $0
80106450:	6a 00                	push   $0x0
  pushl $49
80106452:	6a 31                	push   $0x31
  jmp alltraps
80106454:	e9 8e f8 ff ff       	jmp    80105ce7 <alltraps>

80106459 <vector50>:
.globl vector50
vector50:
  pushl $0
80106459:	6a 00                	push   $0x0
  pushl $50
8010645b:	6a 32                	push   $0x32
  jmp alltraps
8010645d:	e9 85 f8 ff ff       	jmp    80105ce7 <alltraps>

80106462 <vector51>:
.globl vector51
vector51:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $51
80106464:	6a 33                	push   $0x33
  jmp alltraps
80106466:	e9 7c f8 ff ff       	jmp    80105ce7 <alltraps>

8010646b <vector52>:
.globl vector52
vector52:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $52
8010646d:	6a 34                	push   $0x34
  jmp alltraps
8010646f:	e9 73 f8 ff ff       	jmp    80105ce7 <alltraps>

80106474 <vector53>:
.globl vector53
vector53:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $53
80106476:	6a 35                	push   $0x35
  jmp alltraps
80106478:	e9 6a f8 ff ff       	jmp    80105ce7 <alltraps>

8010647d <vector54>:
.globl vector54
vector54:
  pushl $0
8010647d:	6a 00                	push   $0x0
  pushl $54
8010647f:	6a 36                	push   $0x36
  jmp alltraps
80106481:	e9 61 f8 ff ff       	jmp    80105ce7 <alltraps>

80106486 <vector55>:
.globl vector55
vector55:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $55
80106488:	6a 37                	push   $0x37
  jmp alltraps
8010648a:	e9 58 f8 ff ff       	jmp    80105ce7 <alltraps>

8010648f <vector56>:
.globl vector56
vector56:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $56
80106491:	6a 38                	push   $0x38
  jmp alltraps
80106493:	e9 4f f8 ff ff       	jmp    80105ce7 <alltraps>

80106498 <vector57>:
.globl vector57
vector57:
  pushl $0
80106498:	6a 00                	push   $0x0
  pushl $57
8010649a:	6a 39                	push   $0x39
  jmp alltraps
8010649c:	e9 46 f8 ff ff       	jmp    80105ce7 <alltraps>

801064a1 <vector58>:
.globl vector58
vector58:
  pushl $0
801064a1:	6a 00                	push   $0x0
  pushl $58
801064a3:	6a 3a                	push   $0x3a
  jmp alltraps
801064a5:	e9 3d f8 ff ff       	jmp    80105ce7 <alltraps>

801064aa <vector59>:
.globl vector59
vector59:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $59
801064ac:	6a 3b                	push   $0x3b
  jmp alltraps
801064ae:	e9 34 f8 ff ff       	jmp    80105ce7 <alltraps>

801064b3 <vector60>:
.globl vector60
vector60:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $60
801064b5:	6a 3c                	push   $0x3c
  jmp alltraps
801064b7:	e9 2b f8 ff ff       	jmp    80105ce7 <alltraps>

801064bc <vector61>:
.globl vector61
vector61:
  pushl $0
801064bc:	6a 00                	push   $0x0
  pushl $61
801064be:	6a 3d                	push   $0x3d
  jmp alltraps
801064c0:	e9 22 f8 ff ff       	jmp    80105ce7 <alltraps>

801064c5 <vector62>:
.globl vector62
vector62:
  pushl $0
801064c5:	6a 00                	push   $0x0
  pushl $62
801064c7:	6a 3e                	push   $0x3e
  jmp alltraps
801064c9:	e9 19 f8 ff ff       	jmp    80105ce7 <alltraps>

801064ce <vector63>:
.globl vector63
vector63:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $63
801064d0:	6a 3f                	push   $0x3f
  jmp alltraps
801064d2:	e9 10 f8 ff ff       	jmp    80105ce7 <alltraps>

801064d7 <vector64>:
.globl vector64
vector64:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $64
801064d9:	6a 40                	push   $0x40
  jmp alltraps
801064db:	e9 07 f8 ff ff       	jmp    80105ce7 <alltraps>

801064e0 <vector65>:
.globl vector65
vector65:
  pushl $0
801064e0:	6a 00                	push   $0x0
  pushl $65
801064e2:	6a 41                	push   $0x41
  jmp alltraps
801064e4:	e9 fe f7 ff ff       	jmp    80105ce7 <alltraps>

801064e9 <vector66>:
.globl vector66
vector66:
  pushl $0
801064e9:	6a 00                	push   $0x0
  pushl $66
801064eb:	6a 42                	push   $0x42
  jmp alltraps
801064ed:	e9 f5 f7 ff ff       	jmp    80105ce7 <alltraps>

801064f2 <vector67>:
.globl vector67
vector67:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $67
801064f4:	6a 43                	push   $0x43
  jmp alltraps
801064f6:	e9 ec f7 ff ff       	jmp    80105ce7 <alltraps>

801064fb <vector68>:
.globl vector68
vector68:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $68
801064fd:	6a 44                	push   $0x44
  jmp alltraps
801064ff:	e9 e3 f7 ff ff       	jmp    80105ce7 <alltraps>

80106504 <vector69>:
.globl vector69
vector69:
  pushl $0
80106504:	6a 00                	push   $0x0
  pushl $69
80106506:	6a 45                	push   $0x45
  jmp alltraps
80106508:	e9 da f7 ff ff       	jmp    80105ce7 <alltraps>

8010650d <vector70>:
.globl vector70
vector70:
  pushl $0
8010650d:	6a 00                	push   $0x0
  pushl $70
8010650f:	6a 46                	push   $0x46
  jmp alltraps
80106511:	e9 d1 f7 ff ff       	jmp    80105ce7 <alltraps>

80106516 <vector71>:
.globl vector71
vector71:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $71
80106518:	6a 47                	push   $0x47
  jmp alltraps
8010651a:	e9 c8 f7 ff ff       	jmp    80105ce7 <alltraps>

8010651f <vector72>:
.globl vector72
vector72:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $72
80106521:	6a 48                	push   $0x48
  jmp alltraps
80106523:	e9 bf f7 ff ff       	jmp    80105ce7 <alltraps>

80106528 <vector73>:
.globl vector73
vector73:
  pushl $0
80106528:	6a 00                	push   $0x0
  pushl $73
8010652a:	6a 49                	push   $0x49
  jmp alltraps
8010652c:	e9 b6 f7 ff ff       	jmp    80105ce7 <alltraps>

80106531 <vector74>:
.globl vector74
vector74:
  pushl $0
80106531:	6a 00                	push   $0x0
  pushl $74
80106533:	6a 4a                	push   $0x4a
  jmp alltraps
80106535:	e9 ad f7 ff ff       	jmp    80105ce7 <alltraps>

8010653a <vector75>:
.globl vector75
vector75:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $75
8010653c:	6a 4b                	push   $0x4b
  jmp alltraps
8010653e:	e9 a4 f7 ff ff       	jmp    80105ce7 <alltraps>

80106543 <vector76>:
.globl vector76
vector76:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $76
80106545:	6a 4c                	push   $0x4c
  jmp alltraps
80106547:	e9 9b f7 ff ff       	jmp    80105ce7 <alltraps>

8010654c <vector77>:
.globl vector77
vector77:
  pushl $0
8010654c:	6a 00                	push   $0x0
  pushl $77
8010654e:	6a 4d                	push   $0x4d
  jmp alltraps
80106550:	e9 92 f7 ff ff       	jmp    80105ce7 <alltraps>

80106555 <vector78>:
.globl vector78
vector78:
  pushl $0
80106555:	6a 00                	push   $0x0
  pushl $78
80106557:	6a 4e                	push   $0x4e
  jmp alltraps
80106559:	e9 89 f7 ff ff       	jmp    80105ce7 <alltraps>

8010655e <vector79>:
.globl vector79
vector79:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $79
80106560:	6a 4f                	push   $0x4f
  jmp alltraps
80106562:	e9 80 f7 ff ff       	jmp    80105ce7 <alltraps>

80106567 <vector80>:
.globl vector80
vector80:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $80
80106569:	6a 50                	push   $0x50
  jmp alltraps
8010656b:	e9 77 f7 ff ff       	jmp    80105ce7 <alltraps>

80106570 <vector81>:
.globl vector81
vector81:
  pushl $0
80106570:	6a 00                	push   $0x0
  pushl $81
80106572:	6a 51                	push   $0x51
  jmp alltraps
80106574:	e9 6e f7 ff ff       	jmp    80105ce7 <alltraps>

80106579 <vector82>:
.globl vector82
vector82:
  pushl $0
80106579:	6a 00                	push   $0x0
  pushl $82
8010657b:	6a 52                	push   $0x52
  jmp alltraps
8010657d:	e9 65 f7 ff ff       	jmp    80105ce7 <alltraps>

80106582 <vector83>:
.globl vector83
vector83:
  pushl $0
80106582:	6a 00                	push   $0x0
  pushl $83
80106584:	6a 53                	push   $0x53
  jmp alltraps
80106586:	e9 5c f7 ff ff       	jmp    80105ce7 <alltraps>

8010658b <vector84>:
.globl vector84
vector84:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $84
8010658d:	6a 54                	push   $0x54
  jmp alltraps
8010658f:	e9 53 f7 ff ff       	jmp    80105ce7 <alltraps>

80106594 <vector85>:
.globl vector85
vector85:
  pushl $0
80106594:	6a 00                	push   $0x0
  pushl $85
80106596:	6a 55                	push   $0x55
  jmp alltraps
80106598:	e9 4a f7 ff ff       	jmp    80105ce7 <alltraps>

8010659d <vector86>:
.globl vector86
vector86:
  pushl $0
8010659d:	6a 00                	push   $0x0
  pushl $86
8010659f:	6a 56                	push   $0x56
  jmp alltraps
801065a1:	e9 41 f7 ff ff       	jmp    80105ce7 <alltraps>

801065a6 <vector87>:
.globl vector87
vector87:
  pushl $0
801065a6:	6a 00                	push   $0x0
  pushl $87
801065a8:	6a 57                	push   $0x57
  jmp alltraps
801065aa:	e9 38 f7 ff ff       	jmp    80105ce7 <alltraps>

801065af <vector88>:
.globl vector88
vector88:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $88
801065b1:	6a 58                	push   $0x58
  jmp alltraps
801065b3:	e9 2f f7 ff ff       	jmp    80105ce7 <alltraps>

801065b8 <vector89>:
.globl vector89
vector89:
  pushl $0
801065b8:	6a 00                	push   $0x0
  pushl $89
801065ba:	6a 59                	push   $0x59
  jmp alltraps
801065bc:	e9 26 f7 ff ff       	jmp    80105ce7 <alltraps>

801065c1 <vector90>:
.globl vector90
vector90:
  pushl $0
801065c1:	6a 00                	push   $0x0
  pushl $90
801065c3:	6a 5a                	push   $0x5a
  jmp alltraps
801065c5:	e9 1d f7 ff ff       	jmp    80105ce7 <alltraps>

801065ca <vector91>:
.globl vector91
vector91:
  pushl $0
801065ca:	6a 00                	push   $0x0
  pushl $91
801065cc:	6a 5b                	push   $0x5b
  jmp alltraps
801065ce:	e9 14 f7 ff ff       	jmp    80105ce7 <alltraps>

801065d3 <vector92>:
.globl vector92
vector92:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $92
801065d5:	6a 5c                	push   $0x5c
  jmp alltraps
801065d7:	e9 0b f7 ff ff       	jmp    80105ce7 <alltraps>

801065dc <vector93>:
.globl vector93
vector93:
  pushl $0
801065dc:	6a 00                	push   $0x0
  pushl $93
801065de:	6a 5d                	push   $0x5d
  jmp alltraps
801065e0:	e9 02 f7 ff ff       	jmp    80105ce7 <alltraps>

801065e5 <vector94>:
.globl vector94
vector94:
  pushl $0
801065e5:	6a 00                	push   $0x0
  pushl $94
801065e7:	6a 5e                	push   $0x5e
  jmp alltraps
801065e9:	e9 f9 f6 ff ff       	jmp    80105ce7 <alltraps>

801065ee <vector95>:
.globl vector95
vector95:
  pushl $0
801065ee:	6a 00                	push   $0x0
  pushl $95
801065f0:	6a 5f                	push   $0x5f
  jmp alltraps
801065f2:	e9 f0 f6 ff ff       	jmp    80105ce7 <alltraps>

801065f7 <vector96>:
.globl vector96
vector96:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $96
801065f9:	6a 60                	push   $0x60
  jmp alltraps
801065fb:	e9 e7 f6 ff ff       	jmp    80105ce7 <alltraps>

80106600 <vector97>:
.globl vector97
vector97:
  pushl $0
80106600:	6a 00                	push   $0x0
  pushl $97
80106602:	6a 61                	push   $0x61
  jmp alltraps
80106604:	e9 de f6 ff ff       	jmp    80105ce7 <alltraps>

80106609 <vector98>:
.globl vector98
vector98:
  pushl $0
80106609:	6a 00                	push   $0x0
  pushl $98
8010660b:	6a 62                	push   $0x62
  jmp alltraps
8010660d:	e9 d5 f6 ff ff       	jmp    80105ce7 <alltraps>

80106612 <vector99>:
.globl vector99
vector99:
  pushl $0
80106612:	6a 00                	push   $0x0
  pushl $99
80106614:	6a 63                	push   $0x63
  jmp alltraps
80106616:	e9 cc f6 ff ff       	jmp    80105ce7 <alltraps>

8010661b <vector100>:
.globl vector100
vector100:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $100
8010661d:	6a 64                	push   $0x64
  jmp alltraps
8010661f:	e9 c3 f6 ff ff       	jmp    80105ce7 <alltraps>

80106624 <vector101>:
.globl vector101
vector101:
  pushl $0
80106624:	6a 00                	push   $0x0
  pushl $101
80106626:	6a 65                	push   $0x65
  jmp alltraps
80106628:	e9 ba f6 ff ff       	jmp    80105ce7 <alltraps>

8010662d <vector102>:
.globl vector102
vector102:
  pushl $0
8010662d:	6a 00                	push   $0x0
  pushl $102
8010662f:	6a 66                	push   $0x66
  jmp alltraps
80106631:	e9 b1 f6 ff ff       	jmp    80105ce7 <alltraps>

80106636 <vector103>:
.globl vector103
vector103:
  pushl $0
80106636:	6a 00                	push   $0x0
  pushl $103
80106638:	6a 67                	push   $0x67
  jmp alltraps
8010663a:	e9 a8 f6 ff ff       	jmp    80105ce7 <alltraps>

8010663f <vector104>:
.globl vector104
vector104:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $104
80106641:	6a 68                	push   $0x68
  jmp alltraps
80106643:	e9 9f f6 ff ff       	jmp    80105ce7 <alltraps>

80106648 <vector105>:
.globl vector105
vector105:
  pushl $0
80106648:	6a 00                	push   $0x0
  pushl $105
8010664a:	6a 69                	push   $0x69
  jmp alltraps
8010664c:	e9 96 f6 ff ff       	jmp    80105ce7 <alltraps>

80106651 <vector106>:
.globl vector106
vector106:
  pushl $0
80106651:	6a 00                	push   $0x0
  pushl $106
80106653:	6a 6a                	push   $0x6a
  jmp alltraps
80106655:	e9 8d f6 ff ff       	jmp    80105ce7 <alltraps>

8010665a <vector107>:
.globl vector107
vector107:
  pushl $0
8010665a:	6a 00                	push   $0x0
  pushl $107
8010665c:	6a 6b                	push   $0x6b
  jmp alltraps
8010665e:	e9 84 f6 ff ff       	jmp    80105ce7 <alltraps>

80106663 <vector108>:
.globl vector108
vector108:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $108
80106665:	6a 6c                	push   $0x6c
  jmp alltraps
80106667:	e9 7b f6 ff ff       	jmp    80105ce7 <alltraps>

8010666c <vector109>:
.globl vector109
vector109:
  pushl $0
8010666c:	6a 00                	push   $0x0
  pushl $109
8010666e:	6a 6d                	push   $0x6d
  jmp alltraps
80106670:	e9 72 f6 ff ff       	jmp    80105ce7 <alltraps>

80106675 <vector110>:
.globl vector110
vector110:
  pushl $0
80106675:	6a 00                	push   $0x0
  pushl $110
80106677:	6a 6e                	push   $0x6e
  jmp alltraps
80106679:	e9 69 f6 ff ff       	jmp    80105ce7 <alltraps>

8010667e <vector111>:
.globl vector111
vector111:
  pushl $0
8010667e:	6a 00                	push   $0x0
  pushl $111
80106680:	6a 6f                	push   $0x6f
  jmp alltraps
80106682:	e9 60 f6 ff ff       	jmp    80105ce7 <alltraps>

80106687 <vector112>:
.globl vector112
vector112:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $112
80106689:	6a 70                	push   $0x70
  jmp alltraps
8010668b:	e9 57 f6 ff ff       	jmp    80105ce7 <alltraps>

80106690 <vector113>:
.globl vector113
vector113:
  pushl $0
80106690:	6a 00                	push   $0x0
  pushl $113
80106692:	6a 71                	push   $0x71
  jmp alltraps
80106694:	e9 4e f6 ff ff       	jmp    80105ce7 <alltraps>

80106699 <vector114>:
.globl vector114
vector114:
  pushl $0
80106699:	6a 00                	push   $0x0
  pushl $114
8010669b:	6a 72                	push   $0x72
  jmp alltraps
8010669d:	e9 45 f6 ff ff       	jmp    80105ce7 <alltraps>

801066a2 <vector115>:
.globl vector115
vector115:
  pushl $0
801066a2:	6a 00                	push   $0x0
  pushl $115
801066a4:	6a 73                	push   $0x73
  jmp alltraps
801066a6:	e9 3c f6 ff ff       	jmp    80105ce7 <alltraps>

801066ab <vector116>:
.globl vector116
vector116:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $116
801066ad:	6a 74                	push   $0x74
  jmp alltraps
801066af:	e9 33 f6 ff ff       	jmp    80105ce7 <alltraps>

801066b4 <vector117>:
.globl vector117
vector117:
  pushl $0
801066b4:	6a 00                	push   $0x0
  pushl $117
801066b6:	6a 75                	push   $0x75
  jmp alltraps
801066b8:	e9 2a f6 ff ff       	jmp    80105ce7 <alltraps>

801066bd <vector118>:
.globl vector118
vector118:
  pushl $0
801066bd:	6a 00                	push   $0x0
  pushl $118
801066bf:	6a 76                	push   $0x76
  jmp alltraps
801066c1:	e9 21 f6 ff ff       	jmp    80105ce7 <alltraps>

801066c6 <vector119>:
.globl vector119
vector119:
  pushl $0
801066c6:	6a 00                	push   $0x0
  pushl $119
801066c8:	6a 77                	push   $0x77
  jmp alltraps
801066ca:	e9 18 f6 ff ff       	jmp    80105ce7 <alltraps>

801066cf <vector120>:
.globl vector120
vector120:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $120
801066d1:	6a 78                	push   $0x78
  jmp alltraps
801066d3:	e9 0f f6 ff ff       	jmp    80105ce7 <alltraps>

801066d8 <vector121>:
.globl vector121
vector121:
  pushl $0
801066d8:	6a 00                	push   $0x0
  pushl $121
801066da:	6a 79                	push   $0x79
  jmp alltraps
801066dc:	e9 06 f6 ff ff       	jmp    80105ce7 <alltraps>

801066e1 <vector122>:
.globl vector122
vector122:
  pushl $0
801066e1:	6a 00                	push   $0x0
  pushl $122
801066e3:	6a 7a                	push   $0x7a
  jmp alltraps
801066e5:	e9 fd f5 ff ff       	jmp    80105ce7 <alltraps>

801066ea <vector123>:
.globl vector123
vector123:
  pushl $0
801066ea:	6a 00                	push   $0x0
  pushl $123
801066ec:	6a 7b                	push   $0x7b
  jmp alltraps
801066ee:	e9 f4 f5 ff ff       	jmp    80105ce7 <alltraps>

801066f3 <vector124>:
.globl vector124
vector124:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $124
801066f5:	6a 7c                	push   $0x7c
  jmp alltraps
801066f7:	e9 eb f5 ff ff       	jmp    80105ce7 <alltraps>

801066fc <vector125>:
.globl vector125
vector125:
  pushl $0
801066fc:	6a 00                	push   $0x0
  pushl $125
801066fe:	6a 7d                	push   $0x7d
  jmp alltraps
80106700:	e9 e2 f5 ff ff       	jmp    80105ce7 <alltraps>

80106705 <vector126>:
.globl vector126
vector126:
  pushl $0
80106705:	6a 00                	push   $0x0
  pushl $126
80106707:	6a 7e                	push   $0x7e
  jmp alltraps
80106709:	e9 d9 f5 ff ff       	jmp    80105ce7 <alltraps>

8010670e <vector127>:
.globl vector127
vector127:
  pushl $0
8010670e:	6a 00                	push   $0x0
  pushl $127
80106710:	6a 7f                	push   $0x7f
  jmp alltraps
80106712:	e9 d0 f5 ff ff       	jmp    80105ce7 <alltraps>

80106717 <vector128>:
.globl vector128
vector128:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $128
80106719:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010671e:	e9 c4 f5 ff ff       	jmp    80105ce7 <alltraps>

80106723 <vector129>:
.globl vector129
vector129:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $129
80106725:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010672a:	e9 b8 f5 ff ff       	jmp    80105ce7 <alltraps>

8010672f <vector130>:
.globl vector130
vector130:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $130
80106731:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106736:	e9 ac f5 ff ff       	jmp    80105ce7 <alltraps>

8010673b <vector131>:
.globl vector131
vector131:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $131
8010673d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106742:	e9 a0 f5 ff ff       	jmp    80105ce7 <alltraps>

80106747 <vector132>:
.globl vector132
vector132:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $132
80106749:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010674e:	e9 94 f5 ff ff       	jmp    80105ce7 <alltraps>

80106753 <vector133>:
.globl vector133
vector133:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $133
80106755:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010675a:	e9 88 f5 ff ff       	jmp    80105ce7 <alltraps>

8010675f <vector134>:
.globl vector134
vector134:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $134
80106761:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106766:	e9 7c f5 ff ff       	jmp    80105ce7 <alltraps>

8010676b <vector135>:
.globl vector135
vector135:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $135
8010676d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106772:	e9 70 f5 ff ff       	jmp    80105ce7 <alltraps>

80106777 <vector136>:
.globl vector136
vector136:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $136
80106779:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010677e:	e9 64 f5 ff ff       	jmp    80105ce7 <alltraps>

80106783 <vector137>:
.globl vector137
vector137:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $137
80106785:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010678a:	e9 58 f5 ff ff       	jmp    80105ce7 <alltraps>

8010678f <vector138>:
.globl vector138
vector138:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $138
80106791:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106796:	e9 4c f5 ff ff       	jmp    80105ce7 <alltraps>

8010679b <vector139>:
.globl vector139
vector139:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $139
8010679d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801067a2:	e9 40 f5 ff ff       	jmp    80105ce7 <alltraps>

801067a7 <vector140>:
.globl vector140
vector140:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $140
801067a9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801067ae:	e9 34 f5 ff ff       	jmp    80105ce7 <alltraps>

801067b3 <vector141>:
.globl vector141
vector141:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $141
801067b5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801067ba:	e9 28 f5 ff ff       	jmp    80105ce7 <alltraps>

801067bf <vector142>:
.globl vector142
vector142:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $142
801067c1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801067c6:	e9 1c f5 ff ff       	jmp    80105ce7 <alltraps>

801067cb <vector143>:
.globl vector143
vector143:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $143
801067cd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801067d2:	e9 10 f5 ff ff       	jmp    80105ce7 <alltraps>

801067d7 <vector144>:
.globl vector144
vector144:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $144
801067d9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801067de:	e9 04 f5 ff ff       	jmp    80105ce7 <alltraps>

801067e3 <vector145>:
.globl vector145
vector145:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $145
801067e5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801067ea:	e9 f8 f4 ff ff       	jmp    80105ce7 <alltraps>

801067ef <vector146>:
.globl vector146
vector146:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $146
801067f1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801067f6:	e9 ec f4 ff ff       	jmp    80105ce7 <alltraps>

801067fb <vector147>:
.globl vector147
vector147:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $147
801067fd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106802:	e9 e0 f4 ff ff       	jmp    80105ce7 <alltraps>

80106807 <vector148>:
.globl vector148
vector148:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $148
80106809:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010680e:	e9 d4 f4 ff ff       	jmp    80105ce7 <alltraps>

80106813 <vector149>:
.globl vector149
vector149:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $149
80106815:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010681a:	e9 c8 f4 ff ff       	jmp    80105ce7 <alltraps>

8010681f <vector150>:
.globl vector150
vector150:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $150
80106821:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106826:	e9 bc f4 ff ff       	jmp    80105ce7 <alltraps>

8010682b <vector151>:
.globl vector151
vector151:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $151
8010682d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106832:	e9 b0 f4 ff ff       	jmp    80105ce7 <alltraps>

80106837 <vector152>:
.globl vector152
vector152:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $152
80106839:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010683e:	e9 a4 f4 ff ff       	jmp    80105ce7 <alltraps>

80106843 <vector153>:
.globl vector153
vector153:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $153
80106845:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010684a:	e9 98 f4 ff ff       	jmp    80105ce7 <alltraps>

8010684f <vector154>:
.globl vector154
vector154:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $154
80106851:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106856:	e9 8c f4 ff ff       	jmp    80105ce7 <alltraps>

8010685b <vector155>:
.globl vector155
vector155:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $155
8010685d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106862:	e9 80 f4 ff ff       	jmp    80105ce7 <alltraps>

80106867 <vector156>:
.globl vector156
vector156:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $156
80106869:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010686e:	e9 74 f4 ff ff       	jmp    80105ce7 <alltraps>

80106873 <vector157>:
.globl vector157
vector157:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $157
80106875:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010687a:	e9 68 f4 ff ff       	jmp    80105ce7 <alltraps>

8010687f <vector158>:
.globl vector158
vector158:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $158
80106881:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106886:	e9 5c f4 ff ff       	jmp    80105ce7 <alltraps>

8010688b <vector159>:
.globl vector159
vector159:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $159
8010688d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106892:	e9 50 f4 ff ff       	jmp    80105ce7 <alltraps>

80106897 <vector160>:
.globl vector160
vector160:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $160
80106899:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010689e:	e9 44 f4 ff ff       	jmp    80105ce7 <alltraps>

801068a3 <vector161>:
.globl vector161
vector161:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $161
801068a5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801068aa:	e9 38 f4 ff ff       	jmp    80105ce7 <alltraps>

801068af <vector162>:
.globl vector162
vector162:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $162
801068b1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801068b6:	e9 2c f4 ff ff       	jmp    80105ce7 <alltraps>

801068bb <vector163>:
.globl vector163
vector163:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $163
801068bd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801068c2:	e9 20 f4 ff ff       	jmp    80105ce7 <alltraps>

801068c7 <vector164>:
.globl vector164
vector164:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $164
801068c9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801068ce:	e9 14 f4 ff ff       	jmp    80105ce7 <alltraps>

801068d3 <vector165>:
.globl vector165
vector165:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $165
801068d5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801068da:	e9 08 f4 ff ff       	jmp    80105ce7 <alltraps>

801068df <vector166>:
.globl vector166
vector166:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $166
801068e1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801068e6:	e9 fc f3 ff ff       	jmp    80105ce7 <alltraps>

801068eb <vector167>:
.globl vector167
vector167:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $167
801068ed:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801068f2:	e9 f0 f3 ff ff       	jmp    80105ce7 <alltraps>

801068f7 <vector168>:
.globl vector168
vector168:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $168
801068f9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801068fe:	e9 e4 f3 ff ff       	jmp    80105ce7 <alltraps>

80106903 <vector169>:
.globl vector169
vector169:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $169
80106905:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010690a:	e9 d8 f3 ff ff       	jmp    80105ce7 <alltraps>

8010690f <vector170>:
.globl vector170
vector170:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $170
80106911:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106916:	e9 cc f3 ff ff       	jmp    80105ce7 <alltraps>

8010691b <vector171>:
.globl vector171
vector171:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $171
8010691d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106922:	e9 c0 f3 ff ff       	jmp    80105ce7 <alltraps>

80106927 <vector172>:
.globl vector172
vector172:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $172
80106929:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010692e:	e9 b4 f3 ff ff       	jmp    80105ce7 <alltraps>

80106933 <vector173>:
.globl vector173
vector173:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $173
80106935:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010693a:	e9 a8 f3 ff ff       	jmp    80105ce7 <alltraps>

8010693f <vector174>:
.globl vector174
vector174:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $174
80106941:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106946:	e9 9c f3 ff ff       	jmp    80105ce7 <alltraps>

8010694b <vector175>:
.globl vector175
vector175:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $175
8010694d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106952:	e9 90 f3 ff ff       	jmp    80105ce7 <alltraps>

80106957 <vector176>:
.globl vector176
vector176:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $176
80106959:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010695e:	e9 84 f3 ff ff       	jmp    80105ce7 <alltraps>

80106963 <vector177>:
.globl vector177
vector177:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $177
80106965:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010696a:	e9 78 f3 ff ff       	jmp    80105ce7 <alltraps>

8010696f <vector178>:
.globl vector178
vector178:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $178
80106971:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106976:	e9 6c f3 ff ff       	jmp    80105ce7 <alltraps>

8010697b <vector179>:
.globl vector179
vector179:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $179
8010697d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106982:	e9 60 f3 ff ff       	jmp    80105ce7 <alltraps>

80106987 <vector180>:
.globl vector180
vector180:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $180
80106989:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010698e:	e9 54 f3 ff ff       	jmp    80105ce7 <alltraps>

80106993 <vector181>:
.globl vector181
vector181:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $181
80106995:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010699a:	e9 48 f3 ff ff       	jmp    80105ce7 <alltraps>

8010699f <vector182>:
.globl vector182
vector182:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $182
801069a1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801069a6:	e9 3c f3 ff ff       	jmp    80105ce7 <alltraps>

801069ab <vector183>:
.globl vector183
vector183:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $183
801069ad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801069b2:	e9 30 f3 ff ff       	jmp    80105ce7 <alltraps>

801069b7 <vector184>:
.globl vector184
vector184:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $184
801069b9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801069be:	e9 24 f3 ff ff       	jmp    80105ce7 <alltraps>

801069c3 <vector185>:
.globl vector185
vector185:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $185
801069c5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801069ca:	e9 18 f3 ff ff       	jmp    80105ce7 <alltraps>

801069cf <vector186>:
.globl vector186
vector186:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $186
801069d1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801069d6:	e9 0c f3 ff ff       	jmp    80105ce7 <alltraps>

801069db <vector187>:
.globl vector187
vector187:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $187
801069dd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801069e2:	e9 00 f3 ff ff       	jmp    80105ce7 <alltraps>

801069e7 <vector188>:
.globl vector188
vector188:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $188
801069e9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801069ee:	e9 f4 f2 ff ff       	jmp    80105ce7 <alltraps>

801069f3 <vector189>:
.globl vector189
vector189:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $189
801069f5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801069fa:	e9 e8 f2 ff ff       	jmp    80105ce7 <alltraps>

801069ff <vector190>:
.globl vector190
vector190:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $190
80106a01:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106a06:	e9 dc f2 ff ff       	jmp    80105ce7 <alltraps>

80106a0b <vector191>:
.globl vector191
vector191:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $191
80106a0d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106a12:	e9 d0 f2 ff ff       	jmp    80105ce7 <alltraps>

80106a17 <vector192>:
.globl vector192
vector192:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $192
80106a19:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106a1e:	e9 c4 f2 ff ff       	jmp    80105ce7 <alltraps>

80106a23 <vector193>:
.globl vector193
vector193:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $193
80106a25:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106a2a:	e9 b8 f2 ff ff       	jmp    80105ce7 <alltraps>

80106a2f <vector194>:
.globl vector194
vector194:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $194
80106a31:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106a36:	e9 ac f2 ff ff       	jmp    80105ce7 <alltraps>

80106a3b <vector195>:
.globl vector195
vector195:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $195
80106a3d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106a42:	e9 a0 f2 ff ff       	jmp    80105ce7 <alltraps>

80106a47 <vector196>:
.globl vector196
vector196:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $196
80106a49:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106a4e:	e9 94 f2 ff ff       	jmp    80105ce7 <alltraps>

80106a53 <vector197>:
.globl vector197
vector197:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $197
80106a55:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106a5a:	e9 88 f2 ff ff       	jmp    80105ce7 <alltraps>

80106a5f <vector198>:
.globl vector198
vector198:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $198
80106a61:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106a66:	e9 7c f2 ff ff       	jmp    80105ce7 <alltraps>

80106a6b <vector199>:
.globl vector199
vector199:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $199
80106a6d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106a72:	e9 70 f2 ff ff       	jmp    80105ce7 <alltraps>

80106a77 <vector200>:
.globl vector200
vector200:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $200
80106a79:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106a7e:	e9 64 f2 ff ff       	jmp    80105ce7 <alltraps>

80106a83 <vector201>:
.globl vector201
vector201:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $201
80106a85:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106a8a:	e9 58 f2 ff ff       	jmp    80105ce7 <alltraps>

80106a8f <vector202>:
.globl vector202
vector202:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $202
80106a91:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a96:	e9 4c f2 ff ff       	jmp    80105ce7 <alltraps>

80106a9b <vector203>:
.globl vector203
vector203:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $203
80106a9d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106aa2:	e9 40 f2 ff ff       	jmp    80105ce7 <alltraps>

80106aa7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $204
80106aa9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106aae:	e9 34 f2 ff ff       	jmp    80105ce7 <alltraps>

80106ab3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $205
80106ab5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106aba:	e9 28 f2 ff ff       	jmp    80105ce7 <alltraps>

80106abf <vector206>:
.globl vector206
vector206:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $206
80106ac1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106ac6:	e9 1c f2 ff ff       	jmp    80105ce7 <alltraps>

80106acb <vector207>:
.globl vector207
vector207:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $207
80106acd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106ad2:	e9 10 f2 ff ff       	jmp    80105ce7 <alltraps>

80106ad7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $208
80106ad9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106ade:	e9 04 f2 ff ff       	jmp    80105ce7 <alltraps>

80106ae3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $209
80106ae5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106aea:	e9 f8 f1 ff ff       	jmp    80105ce7 <alltraps>

80106aef <vector210>:
.globl vector210
vector210:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $210
80106af1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106af6:	e9 ec f1 ff ff       	jmp    80105ce7 <alltraps>

80106afb <vector211>:
.globl vector211
vector211:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $211
80106afd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106b02:	e9 e0 f1 ff ff       	jmp    80105ce7 <alltraps>

80106b07 <vector212>:
.globl vector212
vector212:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $212
80106b09:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106b0e:	e9 d4 f1 ff ff       	jmp    80105ce7 <alltraps>

80106b13 <vector213>:
.globl vector213
vector213:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $213
80106b15:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106b1a:	e9 c8 f1 ff ff       	jmp    80105ce7 <alltraps>

80106b1f <vector214>:
.globl vector214
vector214:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $214
80106b21:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106b26:	e9 bc f1 ff ff       	jmp    80105ce7 <alltraps>

80106b2b <vector215>:
.globl vector215
vector215:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $215
80106b2d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106b32:	e9 b0 f1 ff ff       	jmp    80105ce7 <alltraps>

80106b37 <vector216>:
.globl vector216
vector216:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $216
80106b39:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106b3e:	e9 a4 f1 ff ff       	jmp    80105ce7 <alltraps>

80106b43 <vector217>:
.globl vector217
vector217:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $217
80106b45:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106b4a:	e9 98 f1 ff ff       	jmp    80105ce7 <alltraps>

80106b4f <vector218>:
.globl vector218
vector218:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $218
80106b51:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106b56:	e9 8c f1 ff ff       	jmp    80105ce7 <alltraps>

80106b5b <vector219>:
.globl vector219
vector219:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $219
80106b5d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106b62:	e9 80 f1 ff ff       	jmp    80105ce7 <alltraps>

80106b67 <vector220>:
.globl vector220
vector220:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $220
80106b69:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106b6e:	e9 74 f1 ff ff       	jmp    80105ce7 <alltraps>

80106b73 <vector221>:
.globl vector221
vector221:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $221
80106b75:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106b7a:	e9 68 f1 ff ff       	jmp    80105ce7 <alltraps>

80106b7f <vector222>:
.globl vector222
vector222:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $222
80106b81:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106b86:	e9 5c f1 ff ff       	jmp    80105ce7 <alltraps>

80106b8b <vector223>:
.globl vector223
vector223:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $223
80106b8d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b92:	e9 50 f1 ff ff       	jmp    80105ce7 <alltraps>

80106b97 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $224
80106b99:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b9e:	e9 44 f1 ff ff       	jmp    80105ce7 <alltraps>

80106ba3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $225
80106ba5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106baa:	e9 38 f1 ff ff       	jmp    80105ce7 <alltraps>

80106baf <vector226>:
.globl vector226
vector226:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $226
80106bb1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106bb6:	e9 2c f1 ff ff       	jmp    80105ce7 <alltraps>

80106bbb <vector227>:
.globl vector227
vector227:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $227
80106bbd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106bc2:	e9 20 f1 ff ff       	jmp    80105ce7 <alltraps>

80106bc7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $228
80106bc9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106bce:	e9 14 f1 ff ff       	jmp    80105ce7 <alltraps>

80106bd3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $229
80106bd5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106bda:	e9 08 f1 ff ff       	jmp    80105ce7 <alltraps>

80106bdf <vector230>:
.globl vector230
vector230:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $230
80106be1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106be6:	e9 fc f0 ff ff       	jmp    80105ce7 <alltraps>

80106beb <vector231>:
.globl vector231
vector231:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $231
80106bed:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106bf2:	e9 f0 f0 ff ff       	jmp    80105ce7 <alltraps>

80106bf7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $232
80106bf9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106bfe:	e9 e4 f0 ff ff       	jmp    80105ce7 <alltraps>

80106c03 <vector233>:
.globl vector233
vector233:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $233
80106c05:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106c0a:	e9 d8 f0 ff ff       	jmp    80105ce7 <alltraps>

80106c0f <vector234>:
.globl vector234
vector234:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $234
80106c11:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106c16:	e9 cc f0 ff ff       	jmp    80105ce7 <alltraps>

80106c1b <vector235>:
.globl vector235
vector235:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $235
80106c1d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106c22:	e9 c0 f0 ff ff       	jmp    80105ce7 <alltraps>

80106c27 <vector236>:
.globl vector236
vector236:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $236
80106c29:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106c2e:	e9 b4 f0 ff ff       	jmp    80105ce7 <alltraps>

80106c33 <vector237>:
.globl vector237
vector237:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $237
80106c35:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106c3a:	e9 a8 f0 ff ff       	jmp    80105ce7 <alltraps>

80106c3f <vector238>:
.globl vector238
vector238:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $238
80106c41:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106c46:	e9 9c f0 ff ff       	jmp    80105ce7 <alltraps>

80106c4b <vector239>:
.globl vector239
vector239:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $239
80106c4d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106c52:	e9 90 f0 ff ff       	jmp    80105ce7 <alltraps>

80106c57 <vector240>:
.globl vector240
vector240:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $240
80106c59:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106c5e:	e9 84 f0 ff ff       	jmp    80105ce7 <alltraps>

80106c63 <vector241>:
.globl vector241
vector241:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $241
80106c65:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106c6a:	e9 78 f0 ff ff       	jmp    80105ce7 <alltraps>

80106c6f <vector242>:
.globl vector242
vector242:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $242
80106c71:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106c76:	e9 6c f0 ff ff       	jmp    80105ce7 <alltraps>

80106c7b <vector243>:
.globl vector243
vector243:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $243
80106c7d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106c82:	e9 60 f0 ff ff       	jmp    80105ce7 <alltraps>

80106c87 <vector244>:
.globl vector244
vector244:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $244
80106c89:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106c8e:	e9 54 f0 ff ff       	jmp    80105ce7 <alltraps>

80106c93 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $245
80106c95:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c9a:	e9 48 f0 ff ff       	jmp    80105ce7 <alltraps>

80106c9f <vector246>:
.globl vector246
vector246:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $246
80106ca1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106ca6:	e9 3c f0 ff ff       	jmp    80105ce7 <alltraps>

80106cab <vector247>:
.globl vector247
vector247:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $247
80106cad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106cb2:	e9 30 f0 ff ff       	jmp    80105ce7 <alltraps>

80106cb7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $248
80106cb9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106cbe:	e9 24 f0 ff ff       	jmp    80105ce7 <alltraps>

80106cc3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $249
80106cc5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106cca:	e9 18 f0 ff ff       	jmp    80105ce7 <alltraps>

80106ccf <vector250>:
.globl vector250
vector250:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $250
80106cd1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106cd6:	e9 0c f0 ff ff       	jmp    80105ce7 <alltraps>

80106cdb <vector251>:
.globl vector251
vector251:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $251
80106cdd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106ce2:	e9 00 f0 ff ff       	jmp    80105ce7 <alltraps>

80106ce7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $252
80106ce9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106cee:	e9 f4 ef ff ff       	jmp    80105ce7 <alltraps>

80106cf3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $253
80106cf5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106cfa:	e9 e8 ef ff ff       	jmp    80105ce7 <alltraps>

80106cff <vector254>:
.globl vector254
vector254:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $254
80106d01:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106d06:	e9 dc ef ff ff       	jmp    80105ce7 <alltraps>

80106d0b <vector255>:
.globl vector255
vector255:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $255
80106d0d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106d12:	e9 d0 ef ff ff       	jmp    80105ce7 <alltraps>
80106d17:	66 90                	xchg   %ax,%ax
80106d19:	66 90                	xchg   %ax,%ax
80106d1b:	66 90                	xchg   %ax,%ax
80106d1d:	66 90                	xchg   %ax,%ax
80106d1f:	90                   	nop

80106d20 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	57                   	push   %edi
80106d24:	56                   	push   %esi
80106d25:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106d26:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106d2c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d32:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106d35:	39 d3                	cmp    %edx,%ebx
80106d37:	73 6c                	jae    80106da5 <deallocuvm.part.0+0x85>
80106d39:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106d3c:	89 c6                	mov    %eax,%esi
80106d3e:	89 d7                	mov    %edx,%edi
80106d40:	eb 28                	jmp    80106d6a <deallocuvm.part.0+0x4a>
80106d42:	eb 1c                	jmp    80106d60 <deallocuvm.part.0+0x40>
80106d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106d4f:	00 
80106d50:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106d57:	00 
80106d58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106d5f:	00 
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106d60:	8d 5a 01             	lea    0x1(%edx),%ebx
80106d63:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106d66:	39 fb                	cmp    %edi,%ebx
80106d68:	73 38                	jae    80106da2 <deallocuvm.part.0+0x82>
  pde = &pgdir[PDX(va)];
80106d6a:	89 da                	mov    %ebx,%edx
80106d6c:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106d6f:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106d72:	a8 01                	test   $0x1,%al
80106d74:	74 ea                	je     80106d60 <deallocuvm.part.0+0x40>
  return &pgtab[PTX(va)];
80106d76:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d78:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106d7d:	c1 e9 0a             	shr    $0xa,%ecx
80106d80:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106d86:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106d8d:	85 c0                	test   %eax,%eax
80106d8f:	74 cf                	je     80106d60 <deallocuvm.part.0+0x40>
    else if((*pte & PTE_P) != 0){
80106d91:	8b 10                	mov    (%eax),%edx
80106d93:	f6 c2 01             	test   $0x1,%dl
80106d96:	75 18                	jne    80106db0 <deallocuvm.part.0+0x90>
  for(; a  < oldsz; a += PGSIZE){
80106d98:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d9e:	39 fb                	cmp    %edi,%ebx
80106da0:	72 c8                	jb     80106d6a <deallocuvm.part.0+0x4a>
80106da2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106da5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106da8:	89 c8                	mov    %ecx,%eax
80106daa:	5b                   	pop    %ebx
80106dab:	5e                   	pop    %esi
80106dac:	5f                   	pop    %edi
80106dad:	5d                   	pop    %ebp
80106dae:	c3                   	ret
80106daf:	90                   	nop
      if(pa == 0)
80106db0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106db6:	74 26                	je     80106dde <deallocuvm.part.0+0xbe>
      kfree(v);
80106db8:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106dbb:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106dc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106dc4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106dca:	52                   	push   %edx
80106dcb:	e8 f0 b7 ff ff       	call   801025c0 <kfree>
      *pte = 0;
80106dd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106dd3:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106dd6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106ddc:	eb 88                	jmp    80106d66 <deallocuvm.part.0+0x46>
        panic("kfree");
80106dde:	83 ec 0c             	sub    $0xc,%esp
80106de1:	68 ac 78 10 80       	push   $0x801078ac
80106de6:	e8 b5 95 ff ff       	call   801003a0 <panic>
80106deb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106df0 <mappages>:
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	57                   	push   %edi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106df4:	8d 7c 0a ff          	lea    -0x1(%edx,%ecx,1),%edi
{
80106df8:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106df9:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80106dff:	89 c6                	mov    %eax,%esi
{
80106e01:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106e02:	89 d3                	mov    %edx,%ebx
80106e04:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106e0a:	83 ec 1c             	sub    $0x1c,%esp
80106e0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106e10:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106e13:	29 d9                	sub    %ebx,%ecx
80106e15:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106e18:	eb 42                	jmp    80106e5c <mappages+0x6c>
80106e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106e20:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106e27:	c1 ea 0a             	shr    $0xa,%edx
80106e2a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106e30:	8d 94 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%edx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106e37:	85 d2                	test   %edx,%edx
80106e39:	74 6d                	je     80106ea8 <mappages+0xb8>
    if(*pte & PTE_P)
80106e3b:	f6 02 01             	testb  $0x1,(%edx)
80106e3e:	0f 85 7e 00 00 00    	jne    80106ec2 <mappages+0xd2>
    *pte = pa | perm | PTE_P;
80106e44:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e47:	01 d8                	add    %ebx,%eax
80106e49:	0b 45 0c             	or     0xc(%ebp),%eax
80106e4c:	83 c8 01             	or     $0x1,%eax
80106e4f:	89 02                	mov    %eax,(%edx)
    if(a == last)
80106e51:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80106e54:	74 62                	je     80106eb8 <mappages+0xc8>
    a += PGSIZE;
80106e56:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pde = &pgdir[PDX(va)];
80106e5c:	89 d8                	mov    %ebx,%eax
80106e5e:	c1 e8 16             	shr    $0x16,%eax
80106e61:	8d 3c 86             	lea    (%esi,%eax,4),%edi
  if(*pde & PTE_P){
80106e64:	8b 07                	mov    (%edi),%eax
80106e66:	a8 01                	test   $0x1,%al
80106e68:	75 b6                	jne    80106e20 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106e6a:	e8 21 b9 ff ff       	call   80102790 <kalloc>
80106e6f:	85 c0                	test   %eax,%eax
80106e71:	74 35                	je     80106ea8 <mappages+0xb8>
    memset(pgtab, 0, PGSIZE);
80106e73:	83 ec 04             	sub    $0x4,%esp
80106e76:	68 00 10 00 00       	push   $0x1000
80106e7b:	6a 00                	push   $0x0
80106e7d:	50                   	push   %eax
80106e7e:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106e81:	e8 7a dc ff ff       	call   80104b00 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e86:	8b 55 dc             	mov    -0x24(%ebp),%edx
  return &pgtab[PTX(va)];
80106e89:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e8c:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106e92:	83 c8 07             	or     $0x7,%eax
80106e95:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106e97:	89 d8                	mov    %ebx,%eax
80106e99:	c1 e8 0a             	shr    $0xa,%eax
80106e9c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106ea1:	01 c2                	add    %eax,%edx
80106ea3:	eb 96                	jmp    80106e3b <mappages+0x4b>
80106ea5:	8d 76 00             	lea    0x0(%esi),%esi
}
80106ea8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106eab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106eb0:	5b                   	pop    %ebx
80106eb1:	5e                   	pop    %esi
80106eb2:	5f                   	pop    %edi
80106eb3:	5d                   	pop    %ebp
80106eb4:	c3                   	ret
80106eb5:	8d 76 00             	lea    0x0(%esi),%esi
80106eb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ebb:	31 c0                	xor    %eax,%eax
}
80106ebd:	5b                   	pop    %ebx
80106ebe:	5e                   	pop    %esi
80106ebf:	5f                   	pop    %edi
80106ec0:	5d                   	pop    %ebp
80106ec1:	c3                   	ret
      panic("remap");
80106ec2:	83 ec 0c             	sub    $0xc,%esp
80106ec5:	68 e0 7a 10 80       	push   $0x80107ae0
80106eca:	e8 d1 94 ff ff       	call   801003a0 <panic>
80106ecf:	90                   	nop

80106ed0 <seginit>:
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106ed6:	e8 a5 cc ff ff       	call   80103b80 <cpuid>
  pd[0] = size-1;
80106edb:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106ee0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106ee6:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80106eed:	ff 00 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ef0:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80106ef7:	ff 00 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106efa:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80106f01:	ff 00 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106f04:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80106f0b:	ff 00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106f0e:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80106f15:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106f18:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80106f1f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106f22:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80106f29:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106f2c:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80106f33:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106f36:	05 10 28 11 80       	add    $0x80112810,%eax
80106f3b:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106f3f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106f43:	c1 e8 10             	shr    $0x10,%eax
80106f46:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106f4a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106f4d:	0f 01 10             	lgdtl  (%eax)
}
80106f50:	c9                   	leave
80106f51:	c3                   	ret
80106f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f5f:	00 

80106f60 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f60:	a1 c4 56 11 80       	mov    0x801156c4,%eax
80106f65:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f6a:	0f 22 d8             	mov    %eax,%cr3
}
80106f6d:	c3                   	ret
80106f6e:	66 90                	xchg   %ax,%ax

80106f70 <switchuvm>:
{
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	57                   	push   %edi
80106f74:	56                   	push   %esi
80106f75:	53                   	push   %ebx
80106f76:	83 ec 1c             	sub    $0x1c,%esp
80106f79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106f7c:	85 db                	test   %ebx,%ebx
80106f7e:	0f 84 c9 00 00 00    	je     8010704d <switchuvm+0xdd>
  if(p->kstack == 0)
80106f84:	8b 43 08             	mov    0x8(%ebx),%eax
80106f87:	85 c0                	test   %eax,%eax
80106f89:	0f 84 d8 00 00 00    	je     80107067 <switchuvm+0xf7>
  if(p->pgdir == 0)
80106f8f:	8b 43 04             	mov    0x4(%ebx),%eax
80106f92:	85 c0                	test   %eax,%eax
80106f94:	0f 84 c0 00 00 00    	je     8010705a <switchuvm+0xea>
  pushcli();
80106f9a:	e8 e1 d8 ff ff       	call   80104880 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f9f:	e8 5c cb ff ff       	call   80103b00 <mycpu>
80106fa4:	89 c6                	mov    %eax,%esi
80106fa6:	e8 55 cb ff ff       	call   80103b00 <mycpu>
80106fab:	8d 78 08             	lea    0x8(%eax),%edi
80106fae:	e8 4d cb ff ff       	call   80103b00 <mycpu>
80106fb3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fb6:	e8 45 cb ff ff       	call   80103b00 <mycpu>
80106fbb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106fbe:	ba 67 00 00 00       	mov    $0x67,%edx
80106fc3:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106fca:	83 c0 08             	add    $0x8,%eax
80106fcd:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106fd4:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106fd9:	83 c1 08             	add    $0x8,%ecx
80106fdc:	c1 e8 18             	shr    $0x18,%eax
80106fdf:	c1 e9 10             	shr    $0x10,%ecx
80106fe2:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
80106fe8:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106fee:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106ff3:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ffa:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106fff:	e8 fc ca ff ff       	call   80103b00 <mycpu>
80107004:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010700b:	e8 f0 ca ff ff       	call   80103b00 <mycpu>
80107010:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107014:	8b 73 08             	mov    0x8(%ebx),%esi
80107017:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010701d:	e8 de ca ff ff       	call   80103b00 <mycpu>
80107022:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107025:	e8 d6 ca ff ff       	call   80103b00 <mycpu>
8010702a:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
8010702e:	b8 28 00 00 00       	mov    $0x28,%eax
80107033:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107036:	8b 43 04             	mov    0x4(%ebx),%eax
80107039:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010703e:	0f 22 d8             	mov    %eax,%cr3
}
80107041:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107044:	5b                   	pop    %ebx
80107045:	5e                   	pop    %esi
80107046:	5f                   	pop    %edi
80107047:	5d                   	pop    %ebp
  popcli();
80107048:	e9 83 d8 ff ff       	jmp    801048d0 <popcli>
    panic("switchuvm: no process");
8010704d:	83 ec 0c             	sub    $0xc,%esp
80107050:	68 e6 7a 10 80       	push   $0x80107ae6
80107055:	e8 46 93 ff ff       	call   801003a0 <panic>
    panic("switchuvm: no pgdir");
8010705a:	83 ec 0c             	sub    $0xc,%esp
8010705d:	68 11 7b 10 80       	push   $0x80107b11
80107062:	e8 39 93 ff ff       	call   801003a0 <panic>
    panic("switchuvm: no kstack");
80107067:	83 ec 0c             	sub    $0xc,%esp
8010706a:	68 fc 7a 10 80       	push   $0x80107afc
8010706f:	e8 2c 93 ff ff       	call   801003a0 <panic>
80107074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107078:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010707f:	00 

80107080 <inituvm>:
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	57                   	push   %edi
80107084:	56                   	push   %esi
80107085:	53                   	push   %ebx
80107086:	83 ec 1c             	sub    $0x1c,%esp
80107089:	8b 45 08             	mov    0x8(%ebp),%eax
8010708c:	8b 75 10             	mov    0x10(%ebp),%esi
8010708f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80107092:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107095:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010709b:	77 49                	ja     801070e6 <inituvm+0x66>
  mem = kalloc();
8010709d:	e8 ee b6 ff ff       	call   80102790 <kalloc>
  memset(mem, 0, PGSIZE);
801070a2:	83 ec 04             	sub    $0x4,%esp
801070a5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801070aa:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801070ac:	6a 00                	push   $0x0
801070ae:	50                   	push   %eax
801070af:	e8 4c da ff ff       	call   80104b00 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801070b4:	58                   	pop    %eax
801070b5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070bb:	5a                   	pop    %edx
801070bc:	6a 06                	push   $0x6
801070be:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070c3:	31 d2                	xor    %edx,%edx
801070c5:	50                   	push   %eax
801070c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070c9:	e8 22 fd ff ff       	call   80106df0 <mappages>
  memmove(mem, init, sz);
801070ce:	83 c4 10             	add    $0x10,%esp
801070d1:	89 75 10             	mov    %esi,0x10(%ebp)
801070d4:	89 7d 0c             	mov    %edi,0xc(%ebp)
801070d7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801070da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070dd:	5b                   	pop    %ebx
801070de:	5e                   	pop    %esi
801070df:	5f                   	pop    %edi
801070e0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801070e1:	e9 aa da ff ff       	jmp    80104b90 <memmove>
    panic("inituvm: more than a page");
801070e6:	83 ec 0c             	sub    $0xc,%esp
801070e9:	68 25 7b 10 80       	push   $0x80107b25
801070ee:	e8 ad 92 ff ff       	call   801003a0 <panic>
801070f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801070f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801070ff:	00 

80107100 <loaduvm>:
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	57                   	push   %edi
80107104:	56                   	push   %esi
80107105:	53                   	push   %ebx
80107106:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107109:	8b 75 0c             	mov    0xc(%ebp),%esi
{
8010710c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
8010710f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80107115:	0f 85 a2 00 00 00    	jne    801071bd <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
8010711b:	85 ff                	test   %edi,%edi
8010711d:	74 7d                	je     8010719c <loaduvm+0x9c>
8010711f:	90                   	nop
  pde = &pgdir[PDX(va)];
80107120:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107123:	8b 55 08             	mov    0x8(%ebp),%edx
80107126:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80107128:	89 c1                	mov    %eax,%ecx
8010712a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010712d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80107130:	f6 c1 01             	test   $0x1,%cl
80107133:	75 13                	jne    80107148 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80107135:	83 ec 0c             	sub    $0xc,%esp
80107138:	68 3f 7b 10 80       	push   $0x80107b3f
8010713d:	e8 5e 92 ff ff       	call   801003a0 <panic>
80107142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107148:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010714b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107151:	25 fc 0f 00 00       	and    $0xffc,%eax
80107156:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010715d:	85 c9                	test   %ecx,%ecx
8010715f:	74 d4                	je     80107135 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80107161:	89 fb                	mov    %edi,%ebx
80107163:	b8 00 10 00 00       	mov    $0x1000,%eax
80107168:	29 f3                	sub    %esi,%ebx
8010716a:	39 c3                	cmp    %eax,%ebx
8010716c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010716f:	53                   	push   %ebx
80107170:	8b 45 14             	mov    0x14(%ebp),%eax
80107173:	01 f0                	add    %esi,%eax
80107175:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80107176:	8b 01                	mov    (%ecx),%eax
80107178:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010717d:	05 00 00 00 80       	add    $0x80000000,%eax
80107182:	50                   	push   %eax
80107183:	ff 75 10             	push   0x10(%ebp)
80107186:	e8 05 aa ff ff       	call   80101b90 <readi>
8010718b:	83 c4 10             	add    $0x10,%esp
8010718e:	39 d8                	cmp    %ebx,%eax
80107190:	75 1e                	jne    801071b0 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80107192:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107198:	39 fe                	cmp    %edi,%esi
8010719a:	72 84                	jb     80107120 <loaduvm+0x20>
}
8010719c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010719f:	31 c0                	xor    %eax,%eax
}
801071a1:	5b                   	pop    %ebx
801071a2:	5e                   	pop    %esi
801071a3:	5f                   	pop    %edi
801071a4:	5d                   	pop    %ebp
801071a5:	c3                   	ret
801071a6:	66 90                	xchg   %ax,%ax
801071a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071af:	00 
801071b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801071b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071b8:	5b                   	pop    %ebx
801071b9:	5e                   	pop    %esi
801071ba:	5f                   	pop    %edi
801071bb:	5d                   	pop    %ebp
801071bc:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
801071bd:	83 ec 0c             	sub    $0xc,%esp
801071c0:	68 60 7d 10 80       	push   $0x80107d60
801071c5:	e8 d6 91 ff ff       	call   801003a0 <panic>
801071ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071d0 <allocuvm>:
{
801071d0:	55                   	push   %ebp
801071d1:	89 e5                	mov    %esp,%ebp
801071d3:	57                   	push   %edi
801071d4:	56                   	push   %esi
801071d5:	53                   	push   %ebx
801071d6:	83 ec 1c             	sub    $0x1c,%esp
801071d9:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
801071dc:	85 f6                	test   %esi,%esi
801071de:	0f 88 99 00 00 00    	js     8010727d <allocuvm+0xad>
801071e4:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
801071e6:	3b 75 0c             	cmp    0xc(%ebp),%esi
801071e9:	0f 82 a1 00 00 00    	jb     80107290 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801071ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801071f2:	05 ff 0f 00 00       	add    $0xfff,%eax
801071f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801071fc:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
801071fe:	39 f0                	cmp    %esi,%eax
80107200:	0f 83 8d 00 00 00    	jae    80107293 <allocuvm+0xc3>
80107206:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80107209:	eb 45                	jmp    80107250 <allocuvm+0x80>
8010720b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107210:	83 ec 04             	sub    $0x4,%esp
80107213:	68 00 10 00 00       	push   $0x1000
80107218:	6a 00                	push   $0x0
8010721a:	50                   	push   %eax
8010721b:	e8 e0 d8 ff ff       	call   80104b00 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107220:	58                   	pop    %eax
80107221:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107227:	5a                   	pop    %edx
80107228:	6a 06                	push   $0x6
8010722a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010722f:	89 fa                	mov    %edi,%edx
80107231:	50                   	push   %eax
80107232:	8b 45 08             	mov    0x8(%ebp),%eax
80107235:	e8 b6 fb ff ff       	call   80106df0 <mappages>
8010723a:	83 c4 10             	add    $0x10,%esp
8010723d:	83 f8 ff             	cmp    $0xffffffff,%eax
80107240:	74 5e                	je     801072a0 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80107242:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107248:	39 f7                	cmp    %esi,%edi
8010724a:	0f 83 88 00 00 00    	jae    801072d8 <allocuvm+0x108>
    mem = kalloc();
80107250:	e8 3b b5 ff ff       	call   80102790 <kalloc>
80107255:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107257:	85 c0                	test   %eax,%eax
80107259:	75 b5                	jne    80107210 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010725b:	83 ec 0c             	sub    $0xc,%esp
8010725e:	68 5d 7b 10 80       	push   $0x80107b5d
80107263:	e8 68 94 ff ff       	call   801006d0 <cprintf>
  if(newsz >= oldsz)
80107268:	83 c4 10             	add    $0x10,%esp
8010726b:	3b 75 0c             	cmp    0xc(%ebp),%esi
8010726e:	74 0d                	je     8010727d <allocuvm+0xad>
80107270:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107273:	8b 45 08             	mov    0x8(%ebp),%eax
80107276:	89 f2                	mov    %esi,%edx
80107278:	e8 a3 fa ff ff       	call   80106d20 <deallocuvm.part.0>
    return 0;
8010727d:	31 d2                	xor    %edx,%edx
}
8010727f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107282:	89 d0                	mov    %edx,%eax
80107284:	5b                   	pop    %ebx
80107285:	5e                   	pop    %esi
80107286:	5f                   	pop    %edi
80107287:	5d                   	pop    %ebp
80107288:	c3                   	ret
80107289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107290:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80107293:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107296:	89 d0                	mov    %edx,%eax
80107298:	5b                   	pop    %ebx
80107299:	5e                   	pop    %esi
8010729a:	5f                   	pop    %edi
8010729b:	5d                   	pop    %ebp
8010729c:	c3                   	ret
8010729d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801072a0:	83 ec 0c             	sub    $0xc,%esp
801072a3:	68 75 7b 10 80       	push   $0x80107b75
801072a8:	e8 23 94 ff ff       	call   801006d0 <cprintf>
  if(newsz >= oldsz)
801072ad:	83 c4 10             	add    $0x10,%esp
801072b0:	3b 75 0c             	cmp    0xc(%ebp),%esi
801072b3:	74 0d                	je     801072c2 <allocuvm+0xf2>
801072b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801072b8:	8b 45 08             	mov    0x8(%ebp),%eax
801072bb:	89 f2                	mov    %esi,%edx
801072bd:	e8 5e fa ff ff       	call   80106d20 <deallocuvm.part.0>
      kfree(mem);
801072c2:	83 ec 0c             	sub    $0xc,%esp
801072c5:	53                   	push   %ebx
801072c6:	e8 f5 b2 ff ff       	call   801025c0 <kfree>
      return 0;
801072cb:	83 c4 10             	add    $0x10,%esp
    return 0;
801072ce:	31 d2                	xor    %edx,%edx
801072d0:	eb ad                	jmp    8010727f <allocuvm+0xaf>
801072d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801072d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
801072db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072de:	5b                   	pop    %ebx
801072df:	5e                   	pop    %esi
801072e0:	89 d0                	mov    %edx,%eax
801072e2:	5f                   	pop    %edi
801072e3:	5d                   	pop    %ebp
801072e4:	c3                   	ret
801072e5:	8d 76 00             	lea    0x0(%esi),%esi
801072e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072ef:	00 

801072f0 <deallocuvm>:
{
801072f0:	55                   	push   %ebp
801072f1:	89 e5                	mov    %esp,%ebp
801072f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801072f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801072f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801072fc:	39 d1                	cmp    %edx,%ecx
801072fe:	73 10                	jae    80107310 <deallocuvm+0x20>
}
80107300:	5d                   	pop    %ebp
80107301:	e9 1a fa ff ff       	jmp    80106d20 <deallocuvm.part.0>
80107306:	66 90                	xchg   %ax,%ax
80107308:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010730f:	00 
80107310:	89 d0                	mov    %edx,%eax
80107312:	5d                   	pop    %ebp
80107313:	c3                   	ret
80107314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107318:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010731f:	00 

80107320 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	83 ec 0c             	sub    $0xc,%esp
80107329:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010732c:	85 f6                	test   %esi,%esi
8010732e:	74 59                	je     80107389 <freevm+0x69>
  if(newsz >= oldsz)
80107330:	31 c9                	xor    %ecx,%ecx
80107332:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107337:	89 f0                	mov    %esi,%eax
80107339:	89 f3                	mov    %esi,%ebx
8010733b:	e8 e0 f9 ff ff       	call   80106d20 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107340:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107346:	eb 0f                	jmp    80107357 <freevm+0x37>
80107348:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010734f:	00 
80107350:	83 c3 04             	add    $0x4,%ebx
80107353:	39 fb                	cmp    %edi,%ebx
80107355:	74 23                	je     8010737a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107357:	8b 03                	mov    (%ebx),%eax
80107359:	a8 01                	test   $0x1,%al
8010735b:	74 f3                	je     80107350 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010735d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107362:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107365:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107368:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010736d:	50                   	push   %eax
8010736e:	e8 4d b2 ff ff       	call   801025c0 <kfree>
80107373:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107376:	39 fb                	cmp    %edi,%ebx
80107378:	75 dd                	jne    80107357 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010737a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010737d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107380:	5b                   	pop    %ebx
80107381:	5e                   	pop    %esi
80107382:	5f                   	pop    %edi
80107383:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107384:	e9 37 b2 ff ff       	jmp    801025c0 <kfree>
    panic("freevm: no pgdir");
80107389:	83 ec 0c             	sub    $0xc,%esp
8010738c:	68 91 7b 10 80       	push   $0x80107b91
80107391:	e8 0a 90 ff ff       	call   801003a0 <panic>
80107396:	66 90                	xchg   %ax,%ax
80107398:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010739f:	00 

801073a0 <setupkvm>:
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	56                   	push   %esi
801073a4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801073a5:	e8 e6 b3 ff ff       	call   80102790 <kalloc>
801073aa:	85 c0                	test   %eax,%eax
801073ac:	74 5e                	je     8010740c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
801073ae:	83 ec 04             	sub    $0x4,%esp
801073b1:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073b3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801073b8:	68 00 10 00 00       	push   $0x1000
801073bd:	6a 00                	push   $0x0
801073bf:	50                   	push   %eax
801073c0:	e8 3b d7 ff ff       	call   80104b00 <memset>
801073c5:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801073c8:	8b 43 04             	mov    0x4(%ebx),%eax
801073cb:	83 ec 08             	sub    $0x8,%esp
801073ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801073d1:	8b 13                	mov    (%ebx),%edx
801073d3:	ff 73 0c             	push   0xc(%ebx)
801073d6:	50                   	push   %eax
801073d7:	29 c1                	sub    %eax,%ecx
801073d9:	89 f0                	mov    %esi,%eax
801073db:	e8 10 fa ff ff       	call   80106df0 <mappages>
801073e0:	83 c4 10             	add    $0x10,%esp
801073e3:	83 f8 ff             	cmp    $0xffffffff,%eax
801073e6:	74 18                	je     80107400 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073e8:	83 c3 10             	add    $0x10,%ebx
801073eb:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801073f1:	75 d5                	jne    801073c8 <setupkvm+0x28>
}
801073f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801073f6:	89 f0                	mov    %esi,%eax
801073f8:	5b                   	pop    %ebx
801073f9:	5e                   	pop    %esi
801073fa:	5d                   	pop    %ebp
801073fb:	c3                   	ret
801073fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107400:	83 ec 0c             	sub    $0xc,%esp
80107403:	56                   	push   %esi
80107404:	e8 17 ff ff ff       	call   80107320 <freevm>
      return 0;
80107409:	83 c4 10             	add    $0x10,%esp
}
8010740c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010740f:	31 f6                	xor    %esi,%esi
}
80107411:	89 f0                	mov    %esi,%eax
80107413:	5b                   	pop    %ebx
80107414:	5e                   	pop    %esi
80107415:	5d                   	pop    %ebp
80107416:	c3                   	ret
80107417:	90                   	nop
80107418:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010741f:	00 

80107420 <kvmalloc>:
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107426:	e8 75 ff ff ff       	call   801073a0 <setupkvm>
8010742b:	a3 c4 56 11 80       	mov    %eax,0x801156c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107430:	05 00 00 00 80       	add    $0x80000000,%eax
80107435:	0f 22 d8             	mov    %eax,%cr3
}
80107438:	c9                   	leave
80107439:	c3                   	ret
8010743a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107440 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107440:	55                   	push   %ebp
80107441:	89 e5                	mov    %esp,%ebp
80107443:	83 ec 08             	sub    $0x8,%esp
80107446:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107449:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010744c:	89 c1                	mov    %eax,%ecx
8010744e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107451:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107454:	f6 c2 01             	test   $0x1,%dl
80107457:	75 17                	jne    80107470 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107459:	83 ec 0c             	sub    $0xc,%esp
8010745c:	68 a2 7b 10 80       	push   $0x80107ba2
80107461:	e8 3a 8f ff ff       	call   801003a0 <panic>
80107466:	66 90                	xchg   %ax,%ax
80107468:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010746f:	00 
  return &pgtab[PTX(va)];
80107470:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107473:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107479:	25 fc 0f 00 00       	and    $0xffc,%eax
8010747e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107485:	85 c0                	test   %eax,%eax
80107487:	74 d0                	je     80107459 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107489:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010748c:	c9                   	leave
8010748d:	c3                   	ret
8010748e:	66 90                	xchg   %ax,%ax

80107490 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	57                   	push   %edi
80107494:	56                   	push   %esi
80107495:	53                   	push   %ebx
80107496:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107499:	e8 02 ff ff ff       	call   801073a0 <setupkvm>
8010749e:	85 c0                	test   %eax,%eax
801074a0:	0f 84 e1 00 00 00    	je     80107587 <copyuvm+0xf7>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801074a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801074a9:	89 c2                	mov    %eax,%edx
801074ab:	85 c9                	test   %ecx,%ecx
801074ad:	0f 84 b5 00 00 00    	je     80107568 <copyuvm+0xd8>
801074b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801074b6:	31 ff                	xor    %edi,%edi
801074b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801074bf:	00 
  if(*pde & PTE_P){
801074c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801074c3:	89 f8                	mov    %edi,%eax
801074c5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801074c8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801074cb:	a8 01                	test   $0x1,%al
801074cd:	75 11                	jne    801074e0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801074cf:	83 ec 0c             	sub    $0xc,%esp
801074d2:	68 ac 7b 10 80       	push   $0x80107bac
801074d7:	e8 c4 8e ff ff       	call   801003a0 <panic>
801074dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801074e0:	89 fa                	mov    %edi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801074e7:	c1 ea 0a             	shr    $0xa,%edx
801074ea:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801074f0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801074f7:	85 c0                	test   %eax,%eax
801074f9:	74 d4                	je     801074cf <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801074fb:	8b 30                	mov    (%eax),%esi
801074fd:	f7 c6 01 00 00 00    	test   $0x1,%esi
80107503:	0f 84 98 00 00 00    	je     801075a1 <copyuvm+0x111>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80107509:	e8 82 b2 ff ff       	call   80102790 <kalloc>
8010750e:	89 c3                	mov    %eax,%ebx
80107510:	85 c0                	test   %eax,%eax
80107512:	74 64                	je     80107578 <copyuvm+0xe8>
    pa = PTE_ADDR(*pte);
80107514:	89 f0                	mov    %esi,%eax
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107516:	83 ec 04             	sub    $0x4,%esp
    flags = PTE_FLAGS(*pte);
80107519:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
    pa = PTE_ADDR(*pte);
8010751f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107524:	68 00 10 00 00       	push   $0x1000
80107529:	05 00 00 00 80       	add    $0x80000000,%eax
8010752e:	50                   	push   %eax
8010752f:	53                   	push   %ebx
80107530:	e8 5b d6 ff ff       	call   80104b90 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107535:	58                   	pop    %eax
80107536:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010753c:	5a                   	pop    %edx
8010753d:	56                   	push   %esi
8010753e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107543:	89 fa                	mov    %edi,%edx
80107545:	50                   	push   %eax
80107546:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107549:	e8 a2 f8 ff ff       	call   80106df0 <mappages>
8010754e:	83 c4 10             	add    $0x10,%esp
80107551:	83 f8 ff             	cmp    $0xffffffff,%eax
80107554:	74 3a                	je     80107590 <copyuvm+0x100>
  for(i = 0; i < sz; i += PGSIZE){
80107556:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010755c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010755f:	0f 82 5b ff ff ff    	jb     801074c0 <copyuvm+0x30>
80107565:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  return d;

bad:
  freevm(d);
  return 0;
}
80107568:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010756b:	89 d0                	mov    %edx,%eax
8010756d:	5b                   	pop    %ebx
8010756e:	5e                   	pop    %esi
8010756f:	5f                   	pop    %edi
80107570:	5d                   	pop    %ebp
80107571:	c3                   	ret
80107572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107578:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  freevm(d);
8010757b:	83 ec 0c             	sub    $0xc,%esp
8010757e:	52                   	push   %edx
8010757f:	e8 9c fd ff ff       	call   80107320 <freevm>
  return 0;
80107584:	83 c4 10             	add    $0x10,%esp
    return 0;
80107587:	31 d2                	xor    %edx,%edx
80107589:	eb dd                	jmp    80107568 <copyuvm+0xd8>
8010758b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107590:	83 ec 0c             	sub    $0xc,%esp
80107593:	53                   	push   %ebx
80107594:	e8 27 b0 ff ff       	call   801025c0 <kfree>
      goto bad;
80107599:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010759c:	83 c4 10             	add    $0x10,%esp
8010759f:	eb da                	jmp    8010757b <copyuvm+0xeb>
      panic("copyuvm: page not present");
801075a1:	83 ec 0c             	sub    $0xc,%esp
801075a4:	68 c6 7b 10 80       	push   $0x80107bc6
801075a9:	e8 f2 8d ff ff       	call   801003a0 <panic>
801075ae:	66 90                	xchg   %ax,%ax

801075b0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801075b6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801075b9:	89 c1                	mov    %eax,%ecx
801075bb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801075be:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801075c1:	f6 c2 01             	test   $0x1,%dl
801075c4:	0f 84 f0 00 00 00    	je     801076ba <uva2ka.cold>
  return &pgtab[PTX(va)];
801075ca:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075cd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801075d3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801075d4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801075d9:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
801075e0:	89 d0                	mov    %edx,%eax
801075e2:	f7 d2                	not    %edx
801075e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801075e9:	05 00 00 00 80       	add    $0x80000000,%eax
801075ee:	83 e2 05             	and    $0x5,%edx
801075f1:	ba 00 00 00 00       	mov    $0x0,%edx
801075f6:	0f 45 c2             	cmovne %edx,%eax
}
801075f9:	c3                   	ret
801075fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107600 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107600:	55                   	push   %ebp
80107601:	89 e5                	mov    %esp,%ebp
80107603:	57                   	push   %edi
80107604:	56                   	push   %esi
80107605:	53                   	push   %ebx
80107606:	83 ec 0c             	sub    $0xc,%esp
80107609:	8b 75 14             	mov    0x14(%ebp),%esi
8010760c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010760f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107612:	85 f6                	test   %esi,%esi
80107614:	75 49                	jne    8010765f <copyout+0x5f>
80107616:	e9 95 00 00 00       	jmp    801076b0 <copyout+0xb0>
8010761b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80107620:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80107625:	05 00 00 00 80       	add    $0x80000000,%eax
8010762a:	74 6e                	je     8010769a <copyout+0x9a>
      return -1;
    n = PGSIZE - (va - va0);
8010762c:	89 fb                	mov    %edi,%ebx
8010762e:	29 cb                	sub    %ecx,%ebx
80107630:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107636:	39 f3                	cmp    %esi,%ebx
80107638:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010763b:	29 f9                	sub    %edi,%ecx
8010763d:	83 ec 04             	sub    $0x4,%esp
80107640:	01 c8                	add    %ecx,%eax
80107642:	53                   	push   %ebx
80107643:	52                   	push   %edx
80107644:	89 55 10             	mov    %edx,0x10(%ebp)
80107647:	50                   	push   %eax
80107648:	e8 43 d5 ff ff       	call   80104b90 <memmove>
    len -= n;
    buf += n;
8010764d:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107650:	8d 8f 00 10 00 00    	lea    0x1000(%edi),%ecx
  while(len > 0){
80107656:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107659:	01 da                	add    %ebx,%edx
  while(len > 0){
8010765b:	29 de                	sub    %ebx,%esi
8010765d:	74 51                	je     801076b0 <copyout+0xb0>
  if(*pde & PTE_P){
8010765f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107662:	89 c8                	mov    %ecx,%eax
    va0 = (uint)PGROUNDDOWN(va);
80107664:	89 cf                	mov    %ecx,%edi
  pde = &pgdir[PDX(va)];
80107666:	c1 e8 16             	shr    $0x16,%eax
    va0 = (uint)PGROUNDDOWN(va);
80107669:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
8010766f:	8b 04 83             	mov    (%ebx,%eax,4),%eax
80107672:	a8 01                	test   $0x1,%al
80107674:	0f 84 47 00 00 00    	je     801076c1 <copyout.cold>
  return &pgtab[PTX(va)];
8010767a:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010767c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107681:	c1 eb 0c             	shr    $0xc,%ebx
80107684:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
8010768a:	8b 84 98 00 00 00 80 	mov    -0x80000000(%eax,%ebx,4),%eax
  if((*pte & PTE_U) == 0)
80107691:	89 c3                	mov    %eax,%ebx
80107693:	f7 d3                	not    %ebx
80107695:	83 e3 05             	and    $0x5,%ebx
80107698:	74 86                	je     80107620 <copyout+0x20>
  }
  return 0;
}
8010769a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010769d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801076a2:	5b                   	pop    %ebx
801076a3:	5e                   	pop    %esi
801076a4:	5f                   	pop    %edi
801076a5:	5d                   	pop    %ebp
801076a6:	c3                   	ret
801076a7:	90                   	nop
801076a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801076af:	00 
801076b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801076b3:	31 c0                	xor    %eax,%eax
}
801076b5:	5b                   	pop    %ebx
801076b6:	5e                   	pop    %esi
801076b7:	5f                   	pop    %edi
801076b8:	5d                   	pop    %ebp
801076b9:	c3                   	ret

801076ba <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801076ba:	a1 00 00 00 00       	mov    0x0,%eax
801076bf:	0f 0b                	ud2

801076c1 <copyout.cold>:
801076c1:	a1 00 00 00 00       	mov    0x0,%eax
801076c6:	0f 0b                	ud2
