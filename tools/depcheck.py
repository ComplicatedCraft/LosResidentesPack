# Comprueba dependencias obligatorias (y rangos de versión) de una carpeta de mods instalada.
# Uso: python3 -I tools/depcheck.py <carpeta>/mods/*.jar
# Avisos "needs minecraft ... has 1.21.1" son falsos positivos (NeoForge los acepta).
import zipfile,sys,io,tomllib,re,json
prov={}; reqs=[]
def vt(s): return [int(x) for x in re.findall(r'\d+',s.split('+')[0].split('-')[0])][:4] or [0]
def inrange(v,rng):
    if not rng or rng=="*" : return True
    for part in re.findall(r'[\[\(][^\]\)]*[\]\)]',rng) or [rng]:
        lo,_,hi=part[1:-1].partition(',') if ',' in part else (part[1:-1],None,part[1:-1])
        ok=True; V=vt(v)
        if lo.strip(): ok&= V>vt(lo) or (part[0]=='[' and V==vt(lo))
        if hi is not None and hi.strip(): ok&= V<vt(hi) or (part[-1]==']' and V==vt(hi))
        if ok: return True
    return False
def scan(z,name):
    names=z.namelist()
    for n in names:
        if n.endswith(".jar") and n.startswith(("META-INF/jarjar/","META-INF/jars/")): scan(zipfile.ZipFile(io.BytesIO(z.read(n))),n)
    if "META-INF/neoforge.mods.toml" not in names: return
    t=tomllib.loads(z.read("META-INF/neoforge.mods.toml").decode())
    man=z.read("META-INF/MANIFEST.MF").decode(errors="ignore") if "META-INF/MANIFEST.MF" in names else ""
    iv=re.search(r'Implementation-Version: *(\S+)',man)
    for m in t.get("mods",[]):
        v=str(m.get("version","0"))
        if "$" in v: v=iv.group(1) if iv else "999"
        prov[m["modId"]]=v
    for deps in t.get("dependencies",{}).values():
        for d in deps:
            if d.get("type","required").lower()=="required" and d.get("side","BOTH").upper()!="SERVER": reqs.append((name.split("/")[-1],d["modId"],d.get("versionRange","")))
for j in sys.argv[1:]: scan(zipfile.ZipFile(j),j)
prov.update(minecraft="1.21.1",neoforge="21.1.266",java="21")  # actualizar si cambia el pack
for who,mid,rng in reqs:
    if mid not in prov: print("MISSING",who,mid,rng)
    elif not inrange(prov[mid],rng): print("VERSION?",who,"needs",mid,rng,"has",prov[mid])
print("checked",len(reqs),"deps")
