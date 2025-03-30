/**
 * I'm very poor lack money
 * plz gimme much much money
 * i wanna alive QAQ...
 * PLZ LET ME ALIVE...
 * PLZ PLZ...
 *
 * @param ss: string
 * @param opt: {
 *                trim: boolean = false,
 *                block: [2]string = ['{%', '%}'],
 *                embed: [2]string = ['{{', '}}'],
 *                comment: [2]string,
 *                buf: string = '_buf',     
 *             }
 * @return string
*/
export function ejs(ss, opt = {}) {
  let trim = opt.trim ?? false
  let block = opt.block ?? ["{%", "%}"]
  let embed = opt.embed ?? ["{{", "}}"]
  let buf = opt.buf ?? "_buf"
  let comment = opt.comment ?? ["{#", "#}"]

  let sz_blk_0 = block[0].length
  let sz_blk_1 = block[1].length
  let sz_emb_0 = embed[0].length
  let sz_emb_1 = embed[1].length
  let rpa = arr => arr.map( s =>
    s.replaceAll(/[\{\[\(\)\]\}]/g, e => {
      return "\\"+e })
    )

  block = rpa(block)
  embed = rpa(embed)
  comment = rpa(comment)

  let ret = '';
  let r = trim ? (new RegExp(`(?:^\s*)?(${block[0]}.*?${block[1]})\s*\n?|(${embed[0]}.*?${embed[1]})|(?:^\s*)?(${comment[0]}.*?${comment[1]})\s*\n?`, 'g'))
               : (new RegExp(`(${block[0]}.*?${block[1]})|(${embed[0]}.*?${embed[1]})|(${comment[0]}.*?${comment[1]})`, 'g'))

  let r_cmt  = new RegExp(`^${comment[0]}.*${comment[1]}$`)
  let r_emb  = new RegExp(`^${embed[0]}.*${embed[1]}$`)
  let r_blk  = new RegExp(`^${block[0]}.*${block[1]}$`)

  ss.split(r).filter(e=>e).map( s => {

    if(s.match(r_emb)) {
      ret += `${buf} += (${s.slice(sz_emb_0,-sz_emb_1)}).toString();\n`;
    } else if(s.match(r_cmt)) {
    } else if(s.match(r_blk)) {
      ret += s.slice(sz_blk_0, -sz_blk_1) + ";\n";
    } else {
      ret += `${buf} += ${JSON.stringify(s)};\n`
    }
  });
  return `let ${buf} = '';\n` + ret + buf;
}
